# encoding: UTF-8
module DNU
  module Fight
    module State
      class Character
        
        @@id = 0
        
        @@nexts = [:target_set, :target, :hitrate, :attack_element, :attack_type, :attack_target, :turn, :act, :add_act,
                   :hit_val, :add_val, :heal_val, :convert_val, :cost_val, :rob_val, :steal_val,
                   :increase_val, :decrease_val, :up_val, :down_val, :reduce_val]
        
        if GameData::BattleValue.table_exists?
          attr_reader *GameData::BattleValue.pluck(:name)
          attr_reader *GameData::BattleValue.pluck(:name).map{|name| "能力#{name}"}
          attr_reader *GameData::BattleValue.where(:has_equip_value => true).pluck(:name).map{|name| "装備#{name}"}
          attr_reader *GameData::BattleValue.where(:has_max => true).pluck(:name).map{|name| "最大#{name}"}
        end
        
        attr_accessor :id, :kind, :name, :object, :pet, :day_i, :team, :parent, :parent_effect, :double, :dead, :turn_end
        
        attr_reader :effects, :effects_parent
        
        def initialize(tree)
          GameData::Character.set_strength_from_rank!(tree)
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
          @id              = @@id += 1
          @parent          = tree[:parent]
          @parent_effect   = tree[:parent_effect]
          @kind            = tree[:kind].to_s
          @name            = tree[:name].to_s
          @object          = tree[:object]
          @pet             = tree[:pet]
          @day_i           = tree[:day_i]
          @team            = tree[:team]
          @effects         = [].extend FindEffects
          @effects_parent  = [].extend FindEffects
          @effects_removed = [].extend FindEffects
          @@nexts.each do |n|
            ['', '_ant'].each do |ant|
              instance_variable_set("@next_#{n}#{ant}", [])
            end
          end
          tree[:settings].try(:each) do |setting|
            add_effects(setting, self, tree[:definitions])
          end
          # 標準必須装備
          equip =  GameData::CharacterType.where(:name => @kind).first.equip
          @require = []
          if equip.present?
            if @effects_parent.type(:Equip).find_all{|r| r.kind.to_sym==equip.kind.to_sym}.blank?
              setting = {
                :equip  =>  {
                  :kind => equip.kind,
                  :name => equip.name,
                  :equip_strength => 10,
                  :settings=>[]
                }
              }
              add_effects(setting, self)
            end
          else
            @require += GameData::Equip.pluck(:name).map{|e|e.to_sym}
          end
          @require.uniq!
          add_disease
        end
        
        def start
          GameData::BattleValue.pluck(:name).each do |stat|
            instance_variable_get("@#{stat}").start
          end
        end
        
        def live
          !@dead
        end
        
        def require
          @require || []
        end
        
        def requires
          (@effects_parent.type(:Equip).map{|e| e.requires }.flatten + require).uniq
        end
        
        def add_effects(setting, parent_obj=nil, def_plus = [])
          type = setting.keys.first
          kind = setting.values.first[:kind].to_s
          name = setting.values.first[:name].to_s
          setting = setting.values.first
          return if [:drop, :hunt, :point].include?(type)
          
          effects = def_plus.try(:find){|d| d.keys.first==type and d[type][:name] == name }.try('[]', type)
          effects = setting if type == :serif
          # 定義されていない場合はデータベースから読み込みを試みる
          if effects.blank?
            if kind.present?
              effects = "GameData::#{type.to_s.camelize}".constantize.find_by_kind_and_name(kind, name).try(:tree)
            else
              effects = "GameData::#{type.to_s.camelize}".constantize.find_by_name(name).try(:tree)
            end
          end
          raise "[#{I18n.t(type.to_s.camelize, :scope => 'DNU.Fight.Scene')}]#{name}は定義されてない" if effects.blank?
          effects.merge!(setting).merge!(:parent => parent_obj)
          es = "DNU::Fight::State::#{type.to_s.camelize}".constantize.new(effects)
          es.each do |e|
            @effects << e
          end
          @effects_parent << es
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
        
        def references
          [object.class.name, object.id]
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
