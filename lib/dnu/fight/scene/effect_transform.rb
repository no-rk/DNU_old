# encoding: UTF-8
class EffectTransform < Parslet::Transform
  
  rule(:number => simple(:number)) {
    number.to_s.tr("０-９．","0-9.")
  }
  
  rule('回避停止') {
    {
      :just_before_attack => { :hit => '命中' }
    }
  }
  
  rule('命中停止') {
    {
      :just_before_attack => { :miss => '空振' }
    }
  }
  
  rule(:arrow => simple(:arrow), :arrow_process => subtree(:arrow_process)) {
    {
      :if => {
        :condition => {
          :just_before_attack => { :hit => '命中' }
        },
        :then => arrow_process
      }
    }
  }
  
  rule(:target_sequence => subtree(:target_sequence)) {
    [target_sequence.delete(:target_condition),target_sequence]
  }
  
  rule(:root => { :passive => subtree(:passive), :do => { :repeat => subtree(:repeat) } }) {
    {
      :repeat => {
        :do => {
          :root => {
            :passive => passive,
            :do => repeat[:do]
          }
        },
        :times => repeat[:times]
      }
    }
  }
  
  rule(:status_percent => subtree(:status_percent)) {
    status_percent[status_percent.keys.first][:right][:state_character][:state_target] = status_percent[status_percent.keys.first][:left][:state_character][:state_target]
    status_percent[status_percent.keys.first][:right][:state_character][:status_name]  = "M" + status_percent[status_percent.keys.first][:left][:state_character][:status_name]
    
    status_percent
  }
  
  rule(:condition_become => subtree(:condition_become)) {
    right = Marshal.load(Marshal.dump(condition_become))
    right[right.keys.first][:left][:state_character_old] = right[right.keys.first][:left].delete(:state_character)
    { :condition_and => {
        :left  => condition_become,
        :right => {
          :condition_not => right
        }
      }
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
                  :hit? => tree
                },
                :then => {
                  :hit => tree
                },
                :else => {
                  :miss => tree
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
