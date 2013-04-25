# encoding: UTF-8
module DNU
  module Fight
    module State
      class Character
        
        @@id = 0
        @@definitions = []
        
        @@nexts = [:target_set, :target, :hitrate, :attack_element, :attack_type, :attack_target, :turn, :act, :add_act,
                   :hit_val, :add_val, :heal_val, :convert_val, :cost_val, :rob_val, :steal_val,
                   :increase_val, :decrease_val, :up_val, :down_val, :reduce_val]
        
        attr_reader *GameData::BattleValue.pluck(:name)
        attr_reader *GameData::BattleValue.pluck(:name).map{|name| "能力#{name}"}
        attr_reader *GameData::BattleValue.where(:has_equip_value => true).pluck(:name).map{|name| "装備#{name}"}
        attr_reader *GameData::BattleValue.where(:has_max => true).pluck(:name).map{|name| "最大#{name}"}
        
        attr_accessor :id, :name, :team, :parent, :parent_effect, :double, :dead, :turn_end
        
        attr_reader :effects
        
        def status_from_rank(rank)
          rank.to_i*15+50
        end
        
        def set_status_from_rank!(tree)
          if tree[:rank].present?
            rank = tree[:rank].to_i + tree[:correction].to_i
            rank = 0 if rank < 0
            
            GameData::Status.pluck(:name).each do |status_name|
              unset = true
              
              tree[:settings].find_all{ |s| s[:status].try('[]', :name).to_s == status_name.to_s }.each do |setting|
                setting[:status][:status_strength] = ((setting[:status][:status_rate] || 1).to_f*status_from_rank(rank)).to_i
                unset = false
              end
              
              if unset
                tree[:settings] << {
                  :status => {
                    :name            => status_name,
                    :status_strength => status_from_rank(rank)
                  }
                }
              end
            end
          end
          tree
        end
        
        def initialize(tree)
          set_status_from_rank!(tree)
          GameData::BattleValue.find_each do |battle_value|
            instance_variable_set("@#{battle_value.name}", DNU::Fight::State::BattleValue.new(battle_value))
            instance_variable_set("@能力#{battle_value.name}", instance_variable_get("@#{battle_value.name}").status)
            if battle_value.has_equip_value
              instance_variable_set("@装備#{battle_value.name}", instance_variable_get("@#{battle_value.name}").equip)
            end
          end
          GameData::BattleValue.where(:has_max => true).pluck(:name).each do |battle_value_name|
            instance_variable_set("@最大#{battle_value_name}", instance_variable_get("@#{battle_value_name}").status.max)
          end
          @id   = @@id += 1
          @parent        = tree[:parent]
          @parent_effect = tree[:parent_effect]
          @name = tree[:name].to_s
          @team = tree[:team]
          @effects         = [].extend FindEffects
          @effects_removed = [].extend FindEffects
          @@nexts.each do |n|
            ['', '_ant'].each do |ant|
              instance_variable_set("@next_#{n}#{ant}", [])
            end
          end
          tree[:settings].try(:each) do |setting|
            add_effects(setting, self, tree[:definitions])
          end
          # 武器なかったら素手にする処理をここに入れる if effects.type(:Weapon).blank?
          add_disease
        end
        
        def start
          GameData::BattleValue.pluck(:name).each do |stat|
            instance_variable_get("@#{stat}").start
          end
        end
        
        def kind
          self.class.name.split("::").last.to_sym
        end
        
        def live
          !@dead
        end
        
        def add_effects(setting, parent_obj=nil, def_plus = [])
          type = setting.keys.first
          name = setting.values.first[:name]
          setting = setting.values.first
          
          return if type == :drop or type == :point
          effects = def_plus.try(:find){|d| d.keys.first==type and d[type][:name] == name } || {}
          effects = @@definitions.find{ |d| d.keys.first==type and d[type][:name] == name } if effects.blank?
          effects = { :serif => setting } if type == :serif
          # 定義されていない場合はデータベースから読み込みを試みる
          if effects.blank?
            tree = "GameData::#{type.to_s.camelize}".constantize.find_by_name(name.to_s).try(:tree)
            if tree.present?
              effects = { type => tree }
              @@definitions.push(effects)
            end
          end
          raise "[#{I18n.t(type.to_s.camelize, :scope => 'DNU.Fight.Scene')}]#{name}は定義されてない" if effects.blank?
          effects = effects[type].merge(setting).merge(:parent => parent_obj)
          es = "DNU::Fight::State::#{type.to_s.camelize}".constantize.new(effects)
          es.each do |e|
            @effects << e
          end
        end
        
        def remove_effects(array)
          @effects = (@effects - array).extend FindEffects
          @effects_removed += array
          array.present?
        end
        
        @@nexts.each do |n|
          ['', '_ant'].each do |ant|
            define_method("next_#{n}#{ant}!") do
              instance_variable_get("@next_#{n}#{ant}").pop
            end
            
            define_method("next_#{n}#{ant}") do
              instance_variable_get("@next_#{n}#{ant}").last
            end
            
            define_method("next_#{n}#{ant}=") do |la|
              instance_variable_set("@next_#{n}#{ant}", [la])
            end
            
            define_method("next_#{n}#{ant}?") do
              instance_variable_get("@next_#{n}#{ant}").present?
            end
          end
        end
        
        def build_double
          double = Marshal.load(Marshal.dump(self))
          double.id = @@id += 1
          double
        end
        
        private
        def add_disease
           GameData::Disease.pluck(:name).each do |name|
            add_effects({ :disease => { :name => name }}, self)
           end
        end
        
      end
    end
  end
end
