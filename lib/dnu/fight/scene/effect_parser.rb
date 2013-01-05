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
  
  rule(:from_to) {
    match('[-~‐－―ー～]') | str('から')
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
  
  rule(:comment) {
    str("#") >> (newline.absent? >> any).repeat(0) >> newline.maybe
  }
  
  # name rule
  
  rule(:hp_mp) {
    str('HP') | str('MP')
  }
  
  rule(:status_name) {
    (
      (hp_mp.absent? >> str('M')).maybe >> hp_mp |
      str('隊列').as(:position) |
      str('射程').as(:range)
    ).as(:status_name) |
    str('装備').as(:equip).maybe >> (
      str('M').maybe >> str('AT') |
      str('M').maybe >> str('DF') |
      str('M').maybe >> str('HIT') |
      str('M').maybe >> str('EVA') |
      str('SPD') |
      (
        (disease_name | element_name) >> (str('特性').as(:Value) | str('耐性').as(:Resist))
      ).as(:value_resist)
    ).as(:status_name)
  }
  
  rule(:disease_name) {
    (
      str('猛毒').as(:Poison) |
      str('麻痺').as(:Palsy) |
      str('睡眠').as(:Sleep) |
      str('泥浸').as(:Mud) |
      str('水濡').as(:Wet) |
      str('炎纏').as(:Burn) |
      str('鎌鼬').as(:Vacuum) |
      str('光身').as(:Shine) |
      str('暗幕').as(:Black) |
      str('混濁').as(:Confuse) |
      str('全状態異常').as(:All)
    ).as(:disease_name)
  }
  
  rule(:element_name) {
    (
      str('無').as(:None) |
      str('火').as(:Fire) |
      str('水').as(:Water) |
      str('地').as(:Earth) |
      str('風').as(:Wind) |
      str('光').as(:Light) |
      str('闇').as(:Dark) |
      str('ラ').as(:Random)
    ).as(:element)
  }
  
  rule(:equip_name) {
    str('剣') |
    str('槍') |
    str('斧') |
    str('弓') |
    str('銃') |
    str('刀') |
    str('素手') |
    str('本') |
    str('魔石') |
    str('杖') |
    str('兜') |
    str('帽子') |
    str('耳') |
    str('盾') |
    str('小手') |
    str('腕輪') |
    str('鎧') |
    str('ローブ') |
    str('服') |
    str('レンズ') |
    str('ピアス') |
    str('オーブ')
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
    (
      str('敵味') |
      str('味敵') |
      str('敵') |
      str('味')
    ) >> str('墓地').maybe
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
  
  # effect_coeff
  
  rule(:level) {
    match('[LＬ]') >> match('[VＶ]')
  }
  
  rule(:calculable) {
    state |
    decimal.as(:fixnum) |
    level.as(:lv) |
    bra >> (
      random_number |
      add_coeff |
      multi_coeff
    ) >> ket
  }
  
  rule(:random_number) {
    (
      (multi_coeff | calculable).as(:from) >> from_to >> (multi_coeff | calculable).as(:to)
    ).as(:random_number)
  }
  
  rule(:add_coeff) {
    (
      (
        multi_coeff |
        calculable
      ) >>
      (
        plus >>
        (
          multi_coeff |
          calculable
        )
      ).repeat(1)
    ).as(:add_coeff)
  }
  
  rule(:multi_coeff) {
    (
      calculable >>
      (
        multiply >>
        calculable
      ).repeat(1)
    ).as(:multi_coeff)
  }
  
  rule(:effect_coeff) {
     random_number | add_coeff | multi_coeff | calculable
  }
  
  # effect
  
  rule(:positive_integer) {
    (
      num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9
    ).as(:number)
  }
  
  rule(:natural_number) {
    (
      num_1_to_9 >> num_0_to_9.repeat(1) | num_1_to_9
    ).as(:number)
  }
  
  rule(:decimal) {
    (
      (num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9 >> dot >> num_0_to_9.repeat(1)) | num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9
    ).as(:number)
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
    (positive_integer >> percent).as(:min_hit) >> (from_to >> (positive_integer >> percent).as(:max_hit)).maybe
  }
  
  rule(:physical) {
    (
               (element_name >> str('属性')).maybe >> physical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> ket |
      const >> (element_name >> str('属性')).maybe >> physical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
    ).as(:physical)
  }
  
  rule(:magical) {
    (
               (element_name >> str('属性')).maybe >>  magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> ket |
      const >> (element_name >> str('属性')).maybe >>  magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
    ).as(:magical)
  }
  
  rule(:physical_magical) {
    (
               (element_name >> str('属性')).maybe >> physical_magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> ket |
      const >> (element_name >> str('属性')).maybe >> physical_magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
    ).as(:physical_magical)
  }
  
  rule(:switch_physical_magical) {
    (
               (element_name >> str('属性')).maybe >> switch_physical_magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> ket |
      const >> (element_name >> str('属性')).maybe >> switch_physical_magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
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
      hp_mp.as(:status_name) >> str('回復') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:heal)
  }
  
  rule(:change) {
    (
      status_name >> str('増加') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:increase) |
    (
      status_name >> str('減少') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:decrease) |
    (
      status_name >> str('上昇') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:up) |
    (
      status_name >> str('低下') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:down) |
    (
      disease_name >> str('軽減') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:reduce) |
    (
      (bra >> str('技') >> ket >> ((str('消費増加') | newline).absent? >> any).repeat(1).as(:name)).maybe >>
      str('消費増加') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost_up) |
    (
      (bra >> str('技') >> ket >> ((str('消費減少') | newline).absent? >> any).repeat(1).as(:name)).maybe >>
      str('消費減少') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost_down)
  }
  
  rule(:disease) {
    (
      disease_name >> str('追加').maybe >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
    ).as(:disease)
  }
  
  rule(:interrupt) {
    (
      (
        str('技').as(:skill) |
        str('付加').as(:sup)
      ) >> str('強制中断')
    ).as(:interrupt)
  }
  
  rule(:vanish) {
    (
      (
        (
          str('技設定').as(:this) |
          bra >> str('技') >> ket >> ((str('の設定') | newline).absent? >> any).repeat(1).as(:name) >> str('の設定')
        ).as(:skill) |
        (
          str('付加').as(:this) |
          bra >> str('付加') >> ket >> ((str('消滅') | newline).absent? >> any).repeat(1).as(:name)
        ).as(:sup)
      ) >> str('消滅')
    ).as(:vanish)
  }
  
  rule(:cost) {
    (
      str('消費') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost)
  }
  
  rule(:serif) {
    str('"') >> 
    (
      str('\\') >> any |
      str('"').absent? >> any
    ).repeat.as(:serif) >> 
    str('"')
  }
  
  rule(:revive) {
    (
      str('蘇生') >> bra >> effect_coeff.as(:change_to) >> (separator >> effect_hit).maybe >> ket
    ).as(:revive)
  }
  
  rule(:next_scope) {
    (single_scope | multi_scope).as(:scope).as(:next_scope)
  }
  
  rule(:next_scopes) {
    str('次の対象範囲') >> bra >> (
      (
        next_scope >> (separator >> next_scope).repeat(1)
      ).as(:random) |
      next_scope
    ) >> ket
  }
  
  rule(:effect) {
    (
      (
        heal |
        change |
        cost |
        next_scopes |
        serif
      ) >> arrow.absent? |
      attack |
      revive |
      disease |
      vanish |
      interrupt
    ).as(:effect)
  }
  
  # effect_condition
  
  rule(:attack_boolean) {
    str('命中').as(:hit) | str('空振').as(:miss)
  }
  
  rule(:disease_boolean) {
    str('追加').as(:add) | str('抵抗').as(:resist)
  }
  
  rule(:effects_boolean) {
    str('成功').as(:success) | str('失敗').as(:failure)
  }
  
  rule(:attack_name) {
    str('攻撃')
  }
  
  rule(:state_target) {
    (
      str('自分') | str('対象')
    ).as(:state_target).maybe
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
  
  rule(:just_before) {
    (
      str('直前') >> (
        attack_name >> attack_boolean |
        str('異常') >> disease_boolean |
        str('効果') >> effects_boolean
      )
    ).as(:just_before)
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
      (
        positive_integer.as(:fixnum) |
        bra >> effect_coeff >> ket
      ) >> percent >> str('の確率').maybe
    ).as(:random_percent)
  }
  
  rule(:condition_boolean) {
    (
      just_before |
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
    positive_integer.as(:fixnum) |
    position_to_fixnum.as(:fixnum)
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
    multiply >> calculable.as(:times)
  }
  
  rule(:while_wrap) {
    separator >> (
      conditions |
      condition |
      str('回避停止') |
      str('命中停止') |
      str('抵抗停止') |
      str('追加停止')
    ).as(:while)
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
  
  # sup_effects
  
  rule(:before_after) {
    str('前').as(:before) |
    str('後').as(:after)
  }
  
  rule(:priority) {
    str('優先度') >> natural_number.as(:priority)
  }
  
  rule(:timing) {
    (
      str('戦闘').as(:battle) |
      str('フェイズ').as(:phase) |
      str('ターン').as(:turn) |
      str('行動').as(:act) |
      str('追加行動').as(:add_act) |
      str('効果').as(:effects) |
      str('対象決定').as(:root) |
      str('攻撃命中').as(:hit) |
      str('攻撃被弾').as(:hit_ant) |
      str('攻撃空振').as(:miss) |
      str('攻撃回避').as(:miss_ant) |
      str('攻撃').as(:attack) |
      str('被攻撃').as(:attack_ant) |
      str('墓地埋葬').as(:cemetery)
    ).as(:timing) >> before_after.as(:before_after)
  }
  
  rule(:sup_effect) {
    bra >> timing >> ket >> (priority >> separator).maybe >> (conditions | condition).as(:condition) >> newline >> root_processes.as(:do)
  }
  
  rule(:sup_effects) {
    sup_effect.repeat(1)
  }
  
  # sup_definition
  
  rule(:sup_definition) {
    bra >> str('付加') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # disease_definition
  
  rule(:disease_definition) {
    bra >> str('異常') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # skill_definition
  
  rule(:pre_phase) {
    str('遠')
  }
  
  rule(:targetable) {
    str('対')
  }
  
  rule(:skill_options) {
    separator >> positive_integer.as(:cost) >>
    (separator >> equip_name.as(:require)).maybe >>
    (separator >> pre_phase.as(:pre_phase)).maybe >>
    (separator >> targetable.as(:targetable)).maybe >> newline
  }
  
  rule(:skill_definition) {
    bra >> str('技') >> ket >> ((skill_options | newline).absent? >> any).repeat(1).as(:name) >> skill_options >>
    root_processes.as(:do).repeat(1).as(:effects)
  }
  
  # serif_definition
  
  rule(:serif_definition) {
    bra >> str('セリフ') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # definitions
  
  rule(:definitions) {
    (
      comment |
      sup_definition.as(:sup) |
      disease_definition.as(:disease) |
      skill_definition.as(:skill) |
      serif_definition.as(:serif)
    ).repeat(1)
  }
  
  # sup_setting
  
  rule(:sup_setting) {
    bra >> str('付加') >> ket >> (
      (level | newline).absent? >> any
    ).repeat(1).as(:name) >> (
      level >> natural_number.as(:lv)
    ).maybe >> newline.maybe
  }
  
  # disease_setting
  
  rule(:disease_setting) {
    bra >> str('異常') >> ket >> (
      newline.absent? >> any
    ).repeat(1).as(:name) >> newline.maybe
  }
  
  # skill_setting
  
  rule(:position_to_fixnum) {
    (str('前') | str('中') | str('後')).as(:position_to_fixnum) >> str('列')
  }
  
  rule(:skill_target) {
    position_to_fixnum.as(:find_by_position) |
    (newline.absent? >> any).repeat(1).as(:find_by_name)
  }
  
  rule(:skill_setting) {
    bra >> str('技') >> ket >> (
      (level | newline).absent? >> any
    ).repeat(1).as(:name) >> (
      level >> natural_number.as(:lv)
    ).maybe >> newline >>
    priority >> separator >> (conditions | condition).as(:condition) >> (
      (newline | separator) >> str('対象') >> separator >> skill_target.as(:target)
    ).maybe >> (
      newline >> root_processes.as(:serif)
    ).maybe >> newline.maybe
  }
  
  # serif_setting
  
  rule(:serif_setting) {
    bra >> str('セリフ') >> ket >> (
      newline.absent? >> any
    ).repeat(1).as(:name) >> newline.maybe
  }
  
  # settings
  
  rule(:settings) {
    (
      comment |
      sup_setting.as(:sup) |
      disease_setting.as(:disease) |
      skill_setting.as(:skill) |
      serif_setting.as(:serif)
    ).repeat(1)
  }
  
  # character_definitions
  
  rule(:character_type) {
    str('PC').as(:PC) |
    str('NPC').as(:NPC) |
    str('モンスター').as(:Monster) |
    str('竜').as(:Dragon) |
    str('人形').as(:Puppet) |
    str('召喚').as(:Summon)
  }
  
  rule(:character_definition) {
    bra >> character_type.as(:type) >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    definitions.as(:definitions).maybe >>
    settings.as(:settings).maybe
  }
  
  rule(:character_definitions) {
    character_definition.repeat(1)
  }
  
  # character_settings
  
  rule(:character_setting) {
    bra >> character_type.as(:type) >> ket >> (
      newline.absent? >> any
    ).repeat(1).as(:name) >> newline.maybe
  }
  
  rule(:character_settings) {
    character_setting.repeat(1)
  }
  
  # pt_settings
  
  rule(:pt_setting) {
    bra >> str('PT') >> ket >> (newline.absent? >> any).repeat(1).as(:pt_name) >> newline >>
    character_settings.as(:members)
  }
  
  rule(:pt_settings) {
    character_definitions.as(:definitions).maybe >>
    pt_setting.repeat(2).as(:settings)
  }
  
  # root
  
  root(:root_processes)
  
end
