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
    spaces? >> match('[-|:/－｜：／・]') >> spaces?
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
    str('敵') | str('味') | str('敵味') | str('味敵')
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
    (scope >> sub_scope.maybe >> target.maybe).as(:passive)
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
  
  rule(:decimal) {
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
    status_name >> multiply >> decimal.as(:coeff_A) >> (plus >> natural_number.as(:coeff_B)).maybe
  }
  
  rule(:effect_hit) {
    (natural_number >> percent).as(:min_hit) >> (separator >> (natural_number >> percent).as(:max_hit)).maybe
  }
  
  rule(:effect) {
    (
      effect_name >> bra >> (effect_coeff | natural_number.as(:coeff_B)) >> ket |
      attack_effect_name >> bra >> (effect_coeff | decimal.as(:coeff_A)) >> (separator >> effect_hit).maybe >> ket |
      const >> attack_effect_name >> bra >> natural_number.as(:coeff_B) >> (separator >> effect_hit).maybe >>ket
    ).as(:effect)
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
    condition_target >> (status_name | disease_name >> str('深度')) >> ((natural_number >> percent).as(:condition_coeff_A) | natural_number.as(:condition_coeff_B)) >> condition_ijyouika.maybe
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
  
  rule(:process) {
    if_process | root_process | processes | effect
  }
  
  rule(:process_wrap) {
    (
      (process | process_wrap).as(:do) >> times_wrap
    ).as(:repeat) |
    (
      (process | process_wrap).as(:do) >> while_wrap
    ).as(:each_effect) |
    (process | process_wrap)
  }
  
  rule(:times_wrap) {
    multiply >> natural_number.as(:times)
  }
  
  rule(:while_wrap) {
    separator >> (conditions | condition | str('回避停止') | str('命中停止')).as(:while)
  }
  
  rule(:if_process) {
    (
      effect_condition.as(:condition) >> process_wrap.as(:then) >> (separator >> process_wrap.as(:else)).maybe
    ).as(:if)
  }
  
  rule(:root_process) {
    (
      passive >> separator.maybe >> process_wrap.as(:do)
    ).as(:root)
  }
  
  rule(:processes) {
    bra >> (
      (
        process_wrap >> (plus >> process_wrap | arrow.as(:arrow) >> effect_condition.absent? >> process_wrap.as(:arrow_process)).repeat(1)
      ).as(:sequence) |
      process_wrap
    ) >> ket
  }
  
  rule(:root_processes) {
    (
      (passive.present? >> process_wrap >> newline.maybe).repeat(2)
    ).as(:sequence) |
    passive.present? >> process_wrap >> newline.maybe
  }
  
  # root
  
  root(:root_processes)
  
end
