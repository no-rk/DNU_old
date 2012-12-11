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
  
  rule(:left => subtree(:left), :arrow => simple(:arrow), :right => subtree(:right)) {
    [
      left,
      {
        :if => {
          :just_before       => '直前',
          :condition_state   => '攻撃',
          :condition_boolean => '成功'
        },
        :then => right
      }
    ].flatten
  }
  
  rule(:left => subtree(:left), :right => subtree(:right)) {
    [
      left,
      right
    ].flatten
  }
  
end
