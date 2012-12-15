# encoding: UTF-8
class EffectTransform < Parslet::Transform
  
  rule(:number => simple(:number)) {
    number.to_s.tr("０-９．","0-9.")
  }
  
  rule('回避停止') {
    {
      :state_effect_boolean => {
        :just_before              => '直前',
        :state_effect_condition   => '攻撃',
        :boolean                  => '成功'
      }
    }
  }
  
  rule('命中停止') {
    {
      :state_effect_boolean => {
        :just_before            => '直前',
        :state_effect_condition => '攻撃',
        :boolean                => '失敗'
      }
    }
  }
  
  rule(:arrow => simple(:arrow), :arrow_process => subtree(:arrow_process)) {
    {
      :if => {
        :condition => {
          :state_effect_boolean => {
            :just_before            => '直前',
            :state_effect_condition => '攻撃',
            :boolean                => '成功'
          }
        },
        :then => arrow_process
      }
    }
  }
  
  rule(:status_percent => subtree(:status_percent)) {
    status_percent[status_percent.keys.first][:right][:state_character][:state_character_target] = status_percent[status_percent.keys.first][:left][:state_character][:state_character_target]
    status_percent[status_percent.keys.first][:right][:state_character][:status_name] = "M" + status_percent[status_percent.keys.first][:left][:state_character][:status_name]
    
    status_percent
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
  
end
