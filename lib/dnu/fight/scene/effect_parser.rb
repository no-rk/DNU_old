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
    spaces? >> (
      match('[→⇒]') |
      match('[=＝]') >> match('[>＞]')
    ) >> spaces?
  }
  # name rule
  
  rule(:hp_mp) {
    str('HP') | str('MP')
  }
  
  rule(:status_name) {
    (
      str('M').maybe >>
      hp_mp
    ).as(:status_name) |
    str('装備').as(:equip).maybe >> (
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
  
  rule(:element_name) {
    (
      str('無') | str('火') | str('水') | str('地') | str('風') | str('光') | str('闇') | str('ラ')
    ).as(:element) >> str('属性')
  }
  
  # passive
  
  rule(:target_condition) {
    (
      str('高') | str('低')
    ).as(:target_condition)
  }
  
  rule(:single_scope) {
    str('自')
  }
  
  rule(:multi_scope) {
    str('敵味') | str('味敵') | str('敵') | str('味')
  }
  
  rule(:single_sub_scope) {
    str('竜')
  }
  
  rule(:multi_sub_scope) {
    str('人形')
  }
  
  rule(:target) {
    (
      str('単') | str('ラ') | str('全') | (target_condition >> (status_name | disease_name) >> str('追尾')).as(:target_sequence)
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
  
  rule(:effect_coeff) {
    status_name >> multiply >> decimal.as(:coeff_A) >> (plus >> natural_number.as(:coeff_B)).maybe
  }
  
  rule(:const) {
    str('固定')
  }
  
  rule(:physical_attack) {
    str('物理攻撃')
  }
  
  rule(:magical_attack) {
    str('魔法攻撃')
  }
  
  rule(:physical_magical_attack) {
    str('純物魔攻撃')
  }
  
  rule(:switch_physical_magical_attack) {
    match('[SＳ]') >> match('[WＷ]') >> str('物魔攻撃')
  }
  
  rule(:effect_hit) {
    (positive_integer >> percent).as(:min_hit) >> (separator >> (positive_integer >> percent).as(:max_hit)).maybe
  }
  
  rule(:physical) {
    (
               element_name.maybe >> physical_attack >> bra >> (effect_coeff | decimal.as(:coeff_A)) >> (separator >> effect_hit).maybe >> ket |
      const >> element_name.maybe >> physical_attack >> bra >>          natural_number.as(:coeff_B)  >> (separator >> effect_hit).maybe >> ket
    ).as(:physical)
  }
  
  rule(:magical) {
    (
               element_name.maybe >>  magical_attack >> bra >> (effect_coeff | decimal.as(:coeff_A)) >> (separator >> effect_hit).maybe >> ket |
      const >> element_name.maybe >>  magical_attack >> bra >>          natural_number.as(:coeff_B)  >> (separator >> effect_hit).maybe >> ket
    ).as(:magical)
  }
  
  rule(:physical_magical) {
    (
               element_name.maybe >> physical_magical_attack >> bra >> (effect_coeff | decimal.as(:coeff_A)) >> (separator >> effect_hit).maybe >> ket |
      const >> element_name.maybe >> physical_magical_attack >> bra >>          natural_number.as(:coeff_B)  >> (separator >> effect_hit).maybe >> ket
    ).as(:physical_magical)
  }
  
  rule(:switch_physical_magical) {
    (
               element_name.maybe >> switch_physical_magical_attack >> bra >> (effect_coeff | decimal.as(:coeff_A)) >> (separator >> effect_hit).maybe >> ket |
      const >> element_name.maybe >> switch_physical_magical_attack >> bra >>          natural_number.as(:coeff_B)  >> (separator >> effect_hit).maybe >> ket
    ).as(:switch_physical_magical)
  }
  
  rule(:attack) {
    (
      physical |
      magical |
      physical_magical |
      switch_physical_magical
    ).as(:attack)
  }
  
  rule(:heal) {
    (
      hp_mp.as(:status_name) >> str('回復') >> bra >> (effect_coeff | natural_number.as(:coeff_B)).as(:change_value) >> ket
    ).as(:heal)
  }
  
  rule(:change) {
    (
      status_name >> str('増加') >> bra >> (effect_coeff | natural_number.as(:coeff_B)).as(:change_value) >> ket
    ).as(:increase) |
    (
      status_name >> str('減少') >> bra >> (effect_coeff | natural_number.as(:coeff_B)).as(:change_value) >> ket
    ).as(:decrease) |
    (
      status_name >> str('上昇') >> bra >> (effect_coeff | natural_number.as(:coeff_B)).as(:change_value) >> ket
    ).as(:up) |
    (
      status_name >> str('低下') >> bra >> (effect_coeff | natural_number.as(:coeff_B)).as(:change_value) >> ket
    ).as(:down) |
    (
      disease_name >> str('軽減') >> bra >> natural_number.as(:coeff_B).as(:change_value) >> ket
    ).as(:reduce)
  }
  
  rule(:disease) {
    (
      disease_name >> str('追加').maybe >> bra >> natural_number.as(:coeff_B).as(:change_value) >> ket
    ).as(:disease)
  }
  
  rule(:serif) {
    str('"') >> 
    (
      str('\\') >> any |
      str('"').absnt? >> any
    ).repeat.as(:serif) >> 
    str('"')
  }
  
  rule(:effect) {
    (
      (
        heal |
        change |
        disease |
        serif
      ) >> arrow.absent? |
      attack
    ).as(:effect)
  }
  
  # effect_condition
  
  rule(:attack_boolean) {
    str('命中').as(:hit) | str('空振').as(:miss)
  }
  
  rule(:disease_boolean) {
    (
      str('追加') | str('抵抗')
    ).as(:disease_boolean)
  }
  
  rule(:just_before) {
    str('直前')
  }
  
  rule(:attack_name) {
    str('攻撃')
  }
  
  rule(:state_target) {
    (
      str('自分') | str('対象')
    ).as(:state_target)
  }
  
  rule(:op_ge) {
    str('以上')
  }
  
  rule(:op_le) {
    str('以下')
  }
  
  rule(:state_effect) {
    (
      attack_name >> attack_boolean >> str('回数')
    ).as(:state_effect)
  }
  
  rule(:just_before_attack) {
    (
      just_before >> attack_name >> attack_boolean
    ).as(:just_before_attack)
  }
  
  rule(:state_character) {
    (
      state_target >> status_name >> (str('の') >> positive_integer.as(:percent) >> percent).maybe
    ).as(:state_character)
  }
  
  rule(:state_disease) {
    (
      state_target >> disease_name >> str('深度')
    ).as(:state_disease)
  }
  
  rule(:status_percent) {
    (
      (
        (state_target >> hp_mp.as(:status_name)).as(:state_character).as(:left) >> positive_integer.as(:percent).as(:state_character).as(:right) >> percent >> op_ge
      ).as(:condition_ge) |
      (
        (state_target >> hp_mp.as(:status_name)).as(:state_character).as(:left) >> positive_integer.as(:percent).as(:state_character).as(:right) >> percent >> op_le
      ).as(:condition_le) |
      (
        (state_target >> hp_mp.as(:status_name)).as(:state_character).as(:left) >> positive_integer.as(:percent).as(:state_character).as(:right) >> percent
      ).as(:condition_eq)
    ).as(:status_percent)
  }
  
  rule(:random_percent) {
    (
      positive_integer >> percent >> str('の確率').maybe
    ).as(:random_percent)
  }
  
  rule(:condition_boolean) {
    (
      just_before_attack |
      random_percent
    ) >> str('になった').absent? |
    status_percent
  }
  
  rule(:state) {
    state_character |
    state_disease |
    state_effect
  }
  
  rule(:condition_coeff) {
    positive_integer.as(:fixnum)
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
      state.as(:left) >> str('が').maybe >> (condition_coeff | state).as(:right)
    ).as(:condition_eq)
  }

  
  rule(:simple_condition) {
    condition_boolean |
    condition_ge |
    condition_le |
    condition_eq
  }
  
  rule(:condition) {
    (simple_condition >> str('になった')).as(:condition_become) |
    simple_condition
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
    if_process | root_process | processes | random_processes | effect
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
  
  rule(:random_processes) {
    bra >> (
      (
        process_wrap >> (separator >> process_wrap).repeat(1)
      ).as(:random) |
      process_wrap
    ) >> ket
  }
  
  rule(:root_processes) {
    (
      (passive.present? >> process_wrap >> newline.maybe).repeat(2)
    ).as(:sequence) |
    passive.present? >> process_wrap >> newline.maybe
  }
  
  # setting
  
  rule(:before_after) {
    str('前').as(:before) |
    str('後').as(:after)
  }
  
  rule(:timing) {
    str('技').as(:effects).as(:timing) >> (ket >> priority).present? |
    (
      str('戦闘').as(:battle) |
      str('フェイズ').as(:phase) |
      str('ターン').as(:turn) |
      str('行動').as(:act) |
      str('追加行動').as(:add_act) |
      str('攻撃命中').as(:hit) |
      str('攻撃回避').as(:miss) |
      str('攻撃').as(:attack) |
      str('効果').as(:effects) |
      str('墓地埋葬').as(:cemetery)
    ).as(:timing) >> before_after.as(:before_after) >> (str('付加').as(:fuka) | str('セリフ').as(:serif)).as(:type)
  }
  
  rule(:priority) {
    str('優先度') >> natural_number.as(:priority)
  }
  
  rule(:setting) {
    bra >> timing >> ket >> (priority >> separator).maybe >> (conditions | condition).as(:condition)
  }
  
  # skill_settings
  
  rule(:skill_setting) {
    setting >> newline >> root_process.as(:do)
  }
  
  rule(:skill_settings) {
    skill_setting >> (newline >> skill_setting).repeat(0) >> newline.maybe
  }
  
  # root
  
  root(:root_processes)
  
end
