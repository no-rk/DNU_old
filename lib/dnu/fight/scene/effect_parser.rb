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
  
  rule(:disease_name) {
    (
      str('猛毒') | str('麻痺') | str('睡眠') | str('泥浸') | str('水濡') | str('炎纏') | str('鎌鼬') | str('光身') | str('暗幕') | str('混濁') | str('全状態異常')
    ).as(:disease_name)
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
  
  rule(:positive_integer) {
    num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9
  }
  
  rule(:natural_number) {
    (
      num_1_to_9 >> num_0_to_9.repeat(1) | num_1_to_9
    ).as(:number)
  }
  
  rule(:decimal) {
    (
      (positive_integer >> dot >> num_0_to_9.repeat(1)) | positive_integer
    ).as(:number)
  }
  
  rule(:attack_effect_name) {
    (
      str('物理攻撃') | str('魔法攻撃')
    ).as(:effect_name)
  }
  
  rule(:effect_name) {
    (
      status_name >> (str('増加') | str('減少') | str('上昇') | str('低下')).as(:effect_detail) |
      (str('HP') | str('MP')).as(:status_name) >> str('回復').as(:effect_detail) |
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
  
  rule(:state_effect_condition) {
    (
      str('攻撃') | str('効果')
    ).as(:state_effect_condition)
  }
  
  rule(:boolean) {
    (
      str('成功') | str('失敗')
    ).as(:boolean)
  }
  
  rule(:just_before) {
    str('直前').as(:just_before)
  }
  
  rule(:state_character_target) {
    (
      str('自分') | str('対象')
    ).as(:state_character_target)
  }
  
  rule(:op_ge) {
    str('以上')
  }
  
  rule(:op_le) {
    str('以下')
  }
  
  rule(:state_effect_boolean) {
    (
      just_before >> state_effect_condition >> boolean
    ).as(:state_effect_boolean)
  }
  
  rule(:state_effect) {
    (
      state_effect_condition >> boolean >> str('回数')
    ).as(:state_effect)
  }
  
  rule(:state_character_boolean) {
    (
      state_character_target >> str('生存').as(:live)
    ).as(:state_character_boolean)
  }
  
  rule(:state_character) {
    (
      state_character_target >> (status_name >> (str('の') >>natural_number.as(:percent) >> percent).maybe | disease_name >> str('深度'))
    ).as(:state_character)
  }
  
  rule(:status_percent) {
    (
      (
        (state_character_target >> (str('HP') | str('MP')).as(:status_name)).as(:state_character).as(:left) >> natural_number.as(:percent).as(:state_character).as(:right) >> percent >> op_ge
      ).as(:condition_ge)
    ).as(:status_percent) |
    (
      (
        (state_character_target >> (str('HP') | str('MP')).as(:status_name)).as(:state_character).as(:left) >> natural_number.as(:percent).as(:state_character).as(:right) >> percent >> op_le
      ).as(:condition_le)
    ).as(:status_percent)
  }
  
  rule(:condition_boolean) {
    state_effect_boolean |
    state_character_boolean |
    status_percent
  }
  
  rule(:state) {
    state_character |
    state_effect
  }
  
  rule(:condition_coeff) {
    natural_number.as(:fixnum)
  }
  
  rule(:condition_ge) {
    (
      state.as(:left) >> (str('が').maybe >> condition_coeff | str('が') >> state).as(:right) >> op_ge
    ).as(:condition_ge)
  }
  
  rule(:condition_le) {
    (
      state.as(:left) >> (str('が').maybe >> condition_coeff | str('が') >> state).as(:right) >> op_le
    ).as(:condition_le)
  }
  
  rule(:condition_eq) {
    (
      state.as(:left) >> str('が') >> (condition_coeff | state).as(:right)
    ).as(:condition_eq)
  }

  
  rule(:condition) {
    condition_boolean |
    condition_ge |
    condition_le |
    condition_eq
  }
  
  rule(:op_and) {
    str('かつ') | str('and')
  }
  
  rule(:op_or) {
    str('または') | str('or')
  }
  
  rule(:condition_and) {
    (
      condition.as(:left) >> op_and >> (conditions | condition).as(:right)
    ).as(:condition_and)
  }
  
  rule(:condition_or) {
    (
      condition.as(:left) >> op_or  >> (conditions | condition).as(:right)
    ).as(:condition_or)
  }
  
  rule(:conditions) {
    condition_and |
    condition_or
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
      process.as(:do) >> times_wrap
    ).as(:repeat) |
    (
      process.as(:do) >> while_wrap
    ).as(:each_effect) |
    process
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
      passive >> (separator | bra.present?) >> process_wrap.as(:do)
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
