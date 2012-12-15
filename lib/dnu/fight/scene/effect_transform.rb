# encoding: UTF-8
class EffectTransform < Parslet::Transform
  
  rule('回避停止') {
    {
      :just_before       => '直前',
      :condition_state   => '攻撃',
      :condition_boolean => '成功'
    }
  }
  
  rule('命中停止') {
    {
      :just_before       => '直前',
      :condition_state   => '攻撃',
      :condition_boolean => '失敗'
    }
  }
  
  rule(:left => subtree(:left), :and => simple(:op), :right => subtree(:right)) {
    { :and => [left,right] }
  }
  
  rule(:left => subtree(:left), :or  => simple(:op), :right => subtree(:right)) {
    { :or  => [left,right] }
  }
  
  rule(:arrow => simple(:arrow), :arrow_process => subtree(:arrow_process)) {
    {
      :if => {
        :condition => {
          :just_before       => '直前',
          :condition_state   => '攻撃',
          :condition_boolean => '成功'
        },
        :then => arrow_process
      }
    }
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
