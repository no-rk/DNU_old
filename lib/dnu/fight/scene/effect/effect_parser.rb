# encoding: UTF-8
class EffectParser < Parslet::Parser
  
  # single character rules
  
  rule(:spaces?) {
    match('[ \t　]').repeat(1).maybe
  }
  
  rule(:newline) {
    match('[\r\n]').repeat(1)
  }
  
  rule(:num_1_to_9) {
    match('[1-9１-９]')
  }
  
  rule(:num_0_to_9) {
    match('[0-9０-９]')
  }
  
  rule(:bra) {
    spaces? >> match('[(\[{（［｛「]') >> spaces?
  }
  
  rule(:ket) {
    spaces? >> match('[)\]}）］｝」]') >> spaces?
  }
  
  rule(:separator) {
    spaces? >> match('[|:/｜：／・]') >> spaces?
  }
  
  rule(:dot) {
    match('[.．]')
  }
  
  rule(:plus) {
    spaces? >> match('[+＋]') >> spaces?
  }
  
  rule(:multiply) {
    spaces? >> match('[*xX＊ｘＸ×]') >> spaces?
  }
  
  rule(:percent) {
    match('[%％]')
  }
  
  rule(:arrow) {
    spaces? >> match('[→⇒]') >> spaces?
  }
  
  # passive
  
  rule(:target_condition) {
    (
      str('高') | str('低')
    ).as(:target_condition)
  }
  
  rule(:status_name) {
    (
      str('M').maybe >> str('HP') |
      str('M').repeat(1,2) >> str('P') |
      str('M').maybe >> str('AT') |
      str('M').maybe >> str('DF') |
      str('M').maybe >> str('HIT') |
      str('M').maybe >> str('EVA') |
      str('SPD')
    ).as(:status_name)
  }
  
  rule(:single_scope) {
    str('自')
  }
  
  rule(:multi_scope) {
    str('敵') | str('味')
  }
  
  rule(:single_sub_scope) {
    str('竜')
  }
  
  rule(:multi_sub_scope) {
    str('人形')
  }
  
  rule(:target) {
    (
      str('単') | str('ラ') | str('全') | (target_condition >> (status_name | disease_name) >> str('追尾'))
    ).as(:target)
  }
  
  rule(:sub_scope) {
    (
      single_sub_scope | (multi_sub_scope >> target.present?)
    ).as(:sub_scope)
  }
  
  rule(:scope) {
    (
      single_scope >> (single_sub_scope.maybe >> target).absent? |
      multi_scope >> (sub_scope.maybe >> target).present?
    ).as(:scope)
  }
  
  rule(:passive) {
    scope >> sub_scope.maybe >> target.maybe
  }
  
  # effect
  
  rule(:const) {
    str('固定')
  }
  
  rule(:boolean) {
    str('成功') | str('失敗')
  }
  
  rule(:natural_number) {
    (num_1_to_9 >> num_0_to_9.repeat(1)) | num_0_to_9
  }
  
  rule(:coeff) {
    (
      (natural_number >> dot >> num_0_to_9.repeat(1)) | natural_number
    )
  }
  
  rule(:attack_effect_name) {
    (
      str('物理攻撃') | str('魔法攻撃')
    ).as(:effect_name)
  }
  
  rule(:effect_name) {
    (
      status_name >> (str('増加') | str('減少') | str('上昇') | str('低下')).as(:effect_detail) |
      disease_name >> (str('追加') | str('軽減')).as(:effect_detail)
    ).as(:effect_name)
  }
  
  rule(:effect_coeff) {
    status_name >> multiply >> coeff.as(:coeff_A) >> (plus >> coeff.as(:coeff_B)).maybe
  }
  
  rule(:effect) {
    effect_name >> bra >> (effect_coeff | coeff.as(:coeff_B)) >> ket |
    attack_effect_name >> bra >> (effect_coeff | coeff.as(:coeff_A)) >> ket |
    const >> attack_effect_name >> bra >> coeff.as(:coeff_B) >>ket
  }
  
  # effect_condition
  
  rule(:disease_name) {
    (
      str('猛毒') | str('麻痺') | str('睡眠') | str('泥浸') | str('水濡') | str('炎纏') | str('鎌鼬') | str('光身') | str('暗幕') | str('混濁') | str('全状態異常')
    ).as(:disease_name)
  }
  
  rule(:condition_state) {
    (
      str('攻撃') | str('効果')
    ).as(:condition_state)
  }
  
  rule(:just_before) {
    str('直前').as(:just_before)
  }
  
  rule(:condition_target) {
    (str('自分') | str('対象')).as(:condition_target)
  }
  
  rule(:condition_ijyouika) {
    (str('以上') | str('以下')).as(:condition_ijyouika)
  }
  
  rule(:condition) {
    just_before >> condition_state >> boolean.as(:condition_boolean) |
    condition_state >> boolean.as(:condition_boolean) >> str('回数') >> natural_number.as(:condition_integer) >> condition_ijyouika.maybe |
    condition_target >> (status_name | disease_name >> str('深度')) >> (natural_number.as(:condition_coeff_A) >> percent | natural_number.as(:condition_coeff_B)) >> condition_ijyouika.maybe
  }
  
  rule(:op_and) {
    str('かつ') | str('and')
  }
  
  rule(:op_or) {
    str('または') | str('or')
  }
  
  rule(:conditions) {
    condition.as(:left) >> op_and.as(:and) >> (conditions | condition).as(:right) |
    condition.as(:left) >> op_or.as(:or)   >> (conditions | condition).as(:right)
  }
  
  rule(:effect_condition) {
    bra >> (conditions | condition) >> ket
  }
  
  # root_processes
  
  rule(:single_process) {
    effect |
    bra >> (processes | process) >> ket |
    effect_condition.as(:if) >> process.as(:then) >> (separator >> process.as(:else)).maybe |
    effect_condition.as(:if) >> bra >> (processes | process).as(:then) >> ket >> (separator >> process.as(:else)).maybe
  }
  
  rule(:multi_process) {
    single_process.as(:repeat) >> multiply >> natural_number.as(:times)
  }
  
  rule(:process) {
    (multi_process | single_process).as(:do_each_effect) >> separator >> (conditions | condition | str('回避停止') | str('命中停止')).as(:while) |
    multi_process | single_process | root_process
  }
  
  rule(:processes) {
    process.as(:left) >> plus >> (processes | process).as(:right) |
    process.as(:left) >> arrow.as(:arrow) >> effect_condition.absent? >> (processes | process).as(:right)
  }
  
  rule(:root_process) {
    passive >> separator >> process.as(:root) |
    passive >> bra >> (processes | process).as(:root) >> ket
  }
  
  rule(:root_processes) {
    (root_process >> newline.maybe).repeat(1)
  }
  
  # root
  
  root(:root_processes)
  
end
