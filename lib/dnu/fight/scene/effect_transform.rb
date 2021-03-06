# encoding: UTF-8
class EffectTransform < Parslet::Transform
  
  rule(:number => simple(:number)) {
    number.to_s.tr("０-９．","0-9.")
  }
  
  rule(:alphabet => simple(:alphabet)) {
    alphabet.to_s.tr("Ａ-Ｚ．","A-Z.")
  }
  
  rule(:color_wrap => simple(:color)) {
    color.to_s.tr("A-ZＡ-Ｚａ-ｚ","a-za-za-z")
  }
  
  rule(:alphabet_number => simple(:alphabet_number)) {
    offset_num = 'A'.ord - 1
    
    alphabet_number.to_s.tr!("Ａ-Ｚ．","A-Z.")
    alphabet_number.to_s.ord - offset_num
  }
  
  rule(:inner_text => simple(:inner_text)) {
    inner_text
  }
  
  rule(:position_to_fixnum => simple(:position)) {
    filter = {
      :"前" => 1,
      :"中" => 2,
      :"後" => 3
    }
    filter[position.to_sym]
  }
  
  rule(:names_wrap => subtree(:names_wrap)) {
    names_wrap.map{|h| h.values.first }
  }
  
  rule(:productable_number_wrap => subtree(:productable_number_wrap)) {
    productable_number_wrap || 1
  }
  
  rule(:correction_wrap => subtree(:correction)) {
    correction[:minus].present? ? -(correction[:value].to_i) : correction[:value].to_i
  }
  
  rule(:battle_value_wrap => subtree(:battle_value)) {
    "#{battle_value[:max]}#{(battle_value[:status_or_equip] || '能力') if battle_value.key?(:status_or_equip)}#{battle_value[:name]}"
  }
  
  rule(:timing_transform => subtree(:timing)) {
    def return_timing(k,v)
      if k==:element
        v.keys.first
      elsif k==:status_name
        v
      else
        k
      end
    end
    { timing.map{ |k,v| return_timing(k,v).to_s.underscore }.join("_").to_sym => timing.map{ |k,v| k==:element ? "#{v.values.first}属性" : v }.join } if timing.respond_to?(:map)
  }
  
  rule(:act_count => subtree(:act_count)) {
    {
      :condition_eq => {
        :left  => { :state_character => { :battle_value => "行動数" } },
        :right => act_count
      }
    }
  }
  
  rule(:wrap_random_percent => subtree(:wrap_random_percent)) {
    case wrap_random_percent.keys.first.to_sym
    when :frequency
      {
        :random_percent => {
          :multi_coeff => [
            { :fixnum => "20" },
            { :fixnum => wrap_random_percent[:frequency] }
          ]
        }
      }
    when :normal
      { :random_percent => { :fixnum => "50" } }
    end
  }
  
  rule(:condition_default => simple(:condition_default)) {
    { :random_percent => { :fixnum => "100" } }
  }
  
  rule(:just_before => { :hit => "命中" }) {
    { :just_before => :Hit }
  }
  
  rule(:just_before => { :miss => "空振" }) {
    { :just_before => :Miss }
  }
  
  rule(:just_before => { :add => "追加" }) {
    { :just_before => :Add }
  }
  
  rule(:just_before => { :resist => "抵抗" }) {
    { :just_before => :Resist }
  }
  
  rule(:just_before => { :success => "成功" }) {
    { :just_before => :success }
  }
  
  rule(:just_before => { :failure => "失敗" }) {
    { :condition_not => { :just_before => :success } }
  }
  
  rule(:value_resist => subtree(:value_resist)) {
    :"#{(value_resist[:disease_name] || value_resist[:element]).keys.first}#{value_resist.key('特性') || value_resist.key('耐性')}"
  }
  
  rule('回避停止') {
    {
      :condition_not => { :just_before => :Miss }
    }
  }
  
  rule('命中停止') {
    {
      :condition_not => { :just_before => :Hit }
    }
  }
  
  rule('抵抗停止') {
    {
      :condition_not => { :just_before => :Resist }
    }
  }
  
  rule('追加停止') {
    {
      :condition_not => { :just_before => :Add }
    }
  }
  
  rule(:change_next_val => subtree(:change_next_val)) {
    { change_next_val.delete(:change_next_type).keys.first => change_next_val }
  }
  
  rule(:arrow => simple(:arrow), :arrow_process => subtree(:arrow_process)) {
    {
      :if => {
        :condition => {
          :condition_or => [
            { :just_before => :Hit },
            { :just_before => :Add },
            { :just_before => :success }
          ]
        },
        :then => arrow_process
      }
    }
  }
  
  rule(:target_sequence => subtree(:target_sequence)) {
    [target_sequence.delete(:target_condition),target_sequence]
  }
  
  rule(:fixnum => { :percent => subtree(:percent) } ) {
    {
      :multi_coeff => [
        percent,
        { :fixnum => 0.01 }
      ]
    }
  }
  
  rule(:has_max_percent => subtree(:has_max_percent)) {
    if has_max_percent.values.first[:left]
      has_max_percent.values.first[:left].values.first.merge!(:ratio => "割合")
    else
      has_max_percent.values.first[:lefts][:do].values.first.merge!(:ratio => "割合")
    end
    has_max_percent
  }
  
  rule(:condition_become => subtree(:condition_become)) {
    right = Marshal.load(Marshal.dump(condition_become))
    def state_before(tree)
      case tree
      when Hash
        tree.each do |(k,v)|
          if [:state_character, :state_disease].include?(k)
            v.merge!(:before => "直前")
          end
          state_before(v)
        end
      when Array
        tree.each do |element|
          state_before(element)
        end
      else
        tree
      end
    end
    { :condition_and => [
        condition_become,
        {
          :condition_not => state_before(right)
        }
      ]
    }
  }
  
  rule(:effect => { :attack => subtree(:attack) }) {
    attack_type = attack.keys.first
    attack[attack_type][:element] ||= '無'
    
    def effect_tree(tree)
      {
        :effect => {
          :attack => {
            :attack_type => tree,
            :do => {
              :if => {
                :condition => {
                  :hit? => {}
                },
                :then => {
                  :if => {
                    :condition => {
                      :critical? => {}
                    },
                    :then => {
                      :hit => { :critical => true }
                    },
                    :else => {
                      :hit => {}
                    }
                  }
                },
                :else => {
                  :miss => {}
                }
              }
            }
          }
        }
      }
    end
    
    if attack_type == :switch_physical_magical
      {
        :if => {
          :condition => {
            :condition_ge => {
              :left  => { :condition_damage => :physical },
              :right => { :condition_damage =>  :magical }
            }
          },
          :then => effect_tree(:physical => attack[:switch_physical_magical]),
          :else => effect_tree( :magical => attack[:switch_physical_magical])
        }
      }
    else
      effect_tree(attack)
    end
  }
  
  rule(:effect => { :disease => subtree(:disease) }) {
    {
      :effect => {
        :disease => disease.merge({
          :do => {
            :if => {
              :condition => {
                :add? => disease
              },
              :then => {
                :add => disease
              },
              :else => {
                :resist => disease
              }
            }
          }
        })
      }
    }
  }
  
end
