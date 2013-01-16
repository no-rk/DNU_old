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
  
  rule(:partition) {
    match('[-]').repeat(1) >> newline
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
  
  rule(:op_ge) {
    match('[≧]') |
    match('[>＞]') >> match('[=＝]')
  }
  
  rule(:op_le) {
    match('[≦]') |
    match('[<＜]') >> match('[=＝]')
  }
  
  rule(:op_eq) {
    match('[=＝]')
  }
  
  rule(:op_and) {
    str('かつ') | str('and')
  }
  
  rule(:op_or) {
    str('または') | str('or')
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
      str('CRI') |
      (
        (disease_name | element_name.as(:element)) >> (str('特性').as(:Value) | str('耐性').as(:Resist))
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
    str('無').as(:None) |
    str('火').as(:Fire) |
    str('水').as(:Water) |
    str('地').as(:Earth) |
    str('風').as(:Wind) |
    str('光').as(:Light) |
    str('闇').as(:Dark) |
    str('ラ').as(:Random)
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
    str('人形') | str('召喚')
  }
  
  rule(:target) {
    (
      str('単') | str('ラ') | str('全') | (target_condition >> (status_name >> str('割合').as(:ratio).maybe | disease_name) >> str('追尾')).as(:target_sequence)
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
    position_to_fixnum.as(:fixnum) |
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
      (
        (
          num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9
        ) >> dot >> num_0_to_9.repeat(1)
      ) |
      num_1_to_9 >> num_0_to_9.repeat(1) | num_0_to_9
    ).as(:number)
  }
  
  rule(:ignore_position) {
    str('隊列無視').as(:ignore_position).maybe
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
    str('命中').maybe   >> (positive_integer >> percent).as(:min_hit) >> (from_to >> (positive_integer >> percent).as(:max_hit)).maybe
  }
  
  rule(:effect_cri) {
    str('クリティカル') >> (positive_integer >> percent).as(:min_cri) >> (from_to >> (positive_integer >> percent).as(:max_cri)).maybe
  }
  
  rule(:physical) {
    (
      ignore_position >>          (element_name.as(:element) >> str('属性')).maybe >> physical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket |
      ignore_position >> const >> (element_name.as(:element) >> str('属性')).maybe >> physical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket
    ).as(:physical)
  }
  
  rule(:magical) {
    (
      ignore_position >>          (element_name.as(:element) >> str('属性')).maybe >>  magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket |
      ignore_position >> const >> (element_name.as(:element) >> str('属性')).maybe >>  magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket
    ).as(:magical)
  }
  
  rule(:physical_magical) {
    (
      ignore_position >>          (element_name.as(:element) >> str('属性')).maybe >> physical_magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket |
      ignore_position >> const >> (element_name.as(:element) >> str('属性')).maybe >> physical_magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket
    ).as(:physical_magical)
  }
  
  rule(:switch_physical_magical) {
    (
      ignore_position >>          (element_name.as(:element) >> str('属性')).maybe >> switch_physical_magical_attack >> bra >> effect_coeff.as(:coeff_value)  >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket |
      ignore_position >> const >> (element_name.as(:element) >> str('属性')).maybe >> switch_physical_magical_attack >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> (separator >> effect_cri).maybe >> ket
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
      status_name >> str('奪取') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:steal) |
    (
      status_name >> str('強奪') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:rob) |
    (
      status_name >> str('変換') >> bra >> effect_coeff.as(:change_to) >> ket
    ).as(:convert) |
    (
      (bra >> str('技') >> ket >> ((str('消費増加') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name)).maybe >>
      str('消費増加') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost_up) |
    (
      (bra >> str('技') >> ket >> ((str('消費減少') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name)).maybe >>
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
          bra >> str('技') >> ket >> ((str('の設定') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name) >> str('の設定')
        ).as(:skill) |
        (
          str('付加').as(:this) |
          bra >> str('付加') >> ket >> ((str('全て') | str('消滅') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name) >> str('全て').as(:all).maybe
        ).as(:sup) |
        (
          str('一時効果').as(:this) |
          bra >> str('一時効果') >> ket >> ((str('全て') | str('消滅') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name) >> str('全て').as(:all).maybe
        ).as(:temporary_effect)
      ) >> str('消滅')
    ).as(:vanish)
  }
  
  rule(:add_effects) {
    (
      (
        bra >> str('付加') >> ket >>
        ((level | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name) >>
        (level >> natural_number.as(:lv)).maybe >>
        (bra >> str('重複不可').as(:unique) >> ket).maybe
      ).as(:sup)
    ).as(:add_effects)
  }
  
  rule(:add_character) {
    (
      bra >> character_type.as(:kind) >> ket >>
      ((separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name) >>
      (bra >> str('重複不可').as(:unique) >> ket).maybe
    ).as(:add_character)
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
  
  rule(:next_damage_coeff) {
    (
      calculable.as(:coeff_value) >> percent >> (separator >> effect_coeff.as(:change_value)).maybe |
      effect_coeff.as(:change_value)
    )
  }
  
  rule(:add_next_damage) {
    (
      (str('次に与える') | str('次に受ける').as(:ant))>>
      attack_timing_options.as(:timing_transform).as(:timing) >>
      str('ダメージ') >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      next_damage_coeff >>
      (separator >> str('重複不可').as(:unique)).maybe >>
      ket
    ).as(:add_next_damage)
  }
  
  rule(:next_damage) {
    (
      str('次の') >> str('被').as(:ant).maybe >>
      str('ダメージ') >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      next_damage_coeff >>
      ket
    ).as(:next_damage)
  }
  
  rule(:effect) {
    (
      (
        heal |
        change |
        cost |
        next_scopes |
        next_damage |
        serif
      ) >> arrow.absent? |
      attack |
      revive |
      disease |
      vanish |
      add_next_damage |
      add_effects |
      add_character |
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
      str('自分') |
      str('対象')
    ).as(:state_target).maybe
  }
  
  rule(:state_target_group) {
    (
      multi_scope.as(:scope) >> (single_sub_scope | multi_sub_scope).as(:sub_scope).maybe |
      single_scope.as(:scope) >> multi_sub_scope.as(:sub_scope)
    ).as(:group)
  }
  
  rule(:group_value) {
    (
      str('最大').as(:max_value) |
      str('最小').as(:min_value) |
      str('平均').as(:avg_value) |
      str('合計').as(:sum_value)
    ).as(:group_value)
  }
  
  rule(:state_effects) {
    (
      str('直前') >> (
        str('ダメージ').as(:attack) |
        (status_name.maybe  >> str('上昇')).as(:up) |
        (status_name.maybe  >> str('低下')).as(:down) |
        (status_name.maybe  >> str('増加')).as(:increase) |
        (status_name.maybe  >> str('減少')).as(:decrease) |
        (disease_name.maybe >> str('軽減')).as(:reduce) |
        (status_name.maybe  >> str('奪取')).as(:steal) |
        (status_name.maybe  >> str('強奪')).as(:rob)
      )
    ).as(:state_effects_just_before_change) |
    (
      str('直後') >> (
        str('ダメージ').as(:attack) |
        (status_name.maybe  >> str('上昇')).as(:up) |
        (status_name.maybe  >> str('低下')).as(:down) |
        (status_name.maybe  >> str('増加')).as(:increase) |
        (status_name.maybe  >> str('減少')).as(:decrease) |
        (disease_name.maybe >> str('軽減')).as(:reduce) |
        (status_name.maybe  >> str('奪取')).as(:steal) |
        (status_name.maybe  >> str('強奪')).as(:rob)
      )
    ).as(:state_effects_just_after_change) |
    (
      (
        str('ダメージ').as(:attack) |
        (status_name.maybe  >> str('上昇')).as(:up) |
        (status_name.maybe  >> str('低下')).as(:down) |
        (status_name.maybe  >> str('増加')).as(:increase) |
        (status_name.maybe  >> str('減少')).as(:decrease) |
        (disease_name.maybe >> str('軽減')).as(:reduce) |
        (status_name.maybe  >> str('奪取')).as(:steal) |
        (status_name.maybe  >> str('強奪')).as(:rob)
      ).as(:scene) >>
      (
        str('合計').as(:sum) |
        str('回数').as(:count)
      ).as(:type)
    ).as(:state_effects_change) |
    (
      (
        bra >> str('技')   >> ket >> ((str('発動回数') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name).as(:skill) |
        bra >> str('付加') >> ket >> ((str('発動回数') | separator | arrow | plus | bra | ket | newline).absent? >> any).repeat(1).as(:name).as(:sup)
      ) >> str('発動回数')
    ).as(:state_effects_count)
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
      state_target       >> status_name >> (str('の') >> positive_integer.as(:percent) >> percent | str('割合').as(:ratio)).maybe |
      state_target_group >> status_name >> (str('の') >> positive_integer.as(:percent) >> percent | str('割合').as(:ratio)).maybe >> group_value
    ).as(:state_character)
  }
  
  rule(:state_disease) {
    (
      state_target       >> disease_name >> str('深度') |
      state_target_group >> disease_name >> str('深度') >> group_value
    ).as(:state_disease)
  }
  
  rule(:hp_mp_percent) {
    (
      (
        (
          (
            state_target       >> hp_mp.as(:status_name) |
            state_target_group >> hp_mp.as(:status_name) >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            hp_mp.as(:status_name).as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        positive_integer.as(:percent).as(:fixnum).as(:right) >>
        percent >> str('以上')
      ).as(:condition_ge) |
      (
        (
          (
            state_target       >> hp_mp.as(:status_name) |
            state_target_group >> hp_mp.as(:status_name) >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            hp_mp.as(:status_name).as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        positive_integer.as(:percent).as(:fixnum).as(:right) >>
        percent >> str('以下')
      ).as(:condition_le) |
      (
        (
          (
            state_target       >> hp_mp.as(:status_name) |
            state_target_group >> hp_mp.as(:status_name) >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            hp_mp.as(:status_name).as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        positive_integer.as(:percent).as(:fixnum).as(:right) >>
        percent
      ).as(:condition_eq)
    ).as(:hp_mp_percent)
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
      (
        just_before |
        random_percent
      ) >> str('になった').absent?
    )
  }
  
  rule(:state) {
    state_effects |
    state_character |
    state_disease
  }
  
  rule(:comparable) {
    state_target_group >> (
      (
        status_name >> (
          str('の') >> positive_integer.as(:percent) >> percent |
          str('割合').as(:ratio)
        ).maybe
      ).as(:state_character).as(:do) |
      disease_name.as(:state_disease).as(:do) >> str('深度')
    )
  }
  
  rule(:comparable_left) {
    calculable.as(:left) |
    comparable.as(:lefts)
  }
  
  rule(:comparable_right) {
    calculable.as(:right) |
    comparable.as(:rights)
  }
  
  rule(:condition_ge) {
    (
      comparable_left >> str('が').maybe >> comparable_right >> str('以上') |
      comparable_left >> op_ge >> comparable_right
    ).as(:condition_ge)
  }
  
  rule(:condition_le) {
    (
      comparable_left >> str('が').maybe >> comparable_right >> str('以下') |
      comparable_left >> op_le >> comparable_right
    ).as(:condition_le)
  }
  
  rule(:condition_eq) {
    (
      comparable_left >> str('が').maybe >> comparable_right |
      comparable_left >> op_eq >> comparable_right
    ).as(:condition_eq)
  }

  
  rule(:simple_condition) {
    condition_boolean |
    hp_mp_percent |
    condition_ge |
    condition_le |
    condition_eq
  }
  
  rule(:condition) {
    (simple_condition >> str('になった')).as(:condition_become) |
    simple_condition |
    bra >> conditions >> ket
  }
  
  rule(:conditions) {
    condition_or |
    condition_and
  }
  
  rule(:condition_or) {
    (
      (
        condition_and |
        condition
      ) >>
      (
        op_or >>
        (
          condition_and |
          condition
        )
      ).repeat(1)
    ).as(:condition_or)
  }
  
  rule(:condition_and) {
    (
      condition >>
      (
        op_and >>
        condition
      ).repeat(1)
    ).as(:condition_and)
  }
  
  rule(:effect_condition) {
    bra >> (conditions | condition) >> ket
  }
  
  # root_processes
  
  rule(:process) {
    if_process | root_process | processes | random_processes | effect
  }
  
  rule(:each_effect) {
    (
      (repeat_effect | process).as(:do) >> while_wrap
    ).as(:each_effect)
  }
  
  rule(:repeat_effect) {
    (
      process.as(:do) >> times_wrap
    ).as(:repeat)
  }
  
  rule(:process_wrap) {
    each_effect |
    repeat_effect |
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
      effect_condition.as(:condition) >> process.as(:then) >> (separator >> process.as(:else)).maybe
    ).as(:if)
  }
  
  rule(:root_process) {
    (
      passive >> (separator | bra.present?) >> process.as(:do)
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
      (
        (effect_condition.maybe >> passive).present? >> process_wrap >> newline.maybe
      ).repeat(2)
    ).as(:sequence) |
    (effect_condition.maybe >> passive).present? >> process_wrap >> newline.maybe
  }
  
  # sup_effects
  
  rule(:before_after) {
    str('前').as(:before) |
    str('後').as(:after)
  }
  
  rule(:priority) {
    str('優先度') >> natural_number.as(:priority)
  }
  
  rule(:attack_timing_options) {
    (element_name.as(:element) >> str('属性')).maybe >>
    (str('物理').as(:physical) | str('魔法').as(:magical)).maybe
  }
  
  rule(:timing) {
    (
      str('戦闘').as(:battle) |
      str('フェイズ').as(:phase) |
      str('ターン').as(:turn) |
      str('行動').as(:act) |
      str('追加行動').as(:add_act) |
      str('通常攻撃').as(:default_attack) |
      str('効果').as(:effects) |
      str('対象決定').as(:root) |
      attack_timing_options >> (
        str('攻撃命中').as(:hit) |
        str('攻撃被弾').as(:hit_ant) |
        str('攻撃空振').as(:miss) |
        str('攻撃回避').as(:miss_ant) |
        str('攻撃').as(:attack) |
        str('被攻撃').as(:attack_ant) |
        str('ダメージ決定').as(:damage) |
        str('被ダメージ決定').as(:damage_ant)
      ) |
      str('クリティカル').as(:critical) |
      str('被クリティカル').as(:critical_ant) |
      str('墓地埋葬').as(:cemetery)
    ).as(:timing_transform).as(:timing) >> before_after.as(:before_after)
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
  
  # temporary_effect_definition
  
  rule(:temporary_effect_definition) {
    bra >> str('一時効果') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
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
    (partition >> sup_definition.as(:sup).repeat(1).as(:definitions) >> partition).maybe >>
    root_processes.as(:do).repeat(1).as(:effects)
  }
  
  # serif_definition
  
  rule(:serif_definition) {
    bra >> str('セリフ') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # ability_definition
  
  rule(:ability_definition) {
    bra >> str('アビリティ') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    partition >> (partition.absent? >> any).repeat(1).as(:caption) >> partition >>
    sup_effects.as(:effects) >>
    (
      level >> natural_number.as(:lv) >> separator >> (newline.absent? >> any).repeat(1).as(:caption) >> newline >>
      sup_effects.as(:effects)
    ).repeat(0).as(:definitions)
  }
  
  # definitions
  
  rule(:definitions) {
    (
      comment |
      ability_definition.as(:ability) |
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
  
  # ability_setting
  
  rule(:ability_setting) {
    bra >> str('アビリティ') >> ket >>
    (level.absent? >> any).repeat(1).as(:name) >>
    level >> natural_number.as(:lv) >> newline.maybe
  }
  
  # settings
  
  rule(:settings) {
    (
      comment |
      ability_setting.as(:ability) |
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
    bra >> character_type.as(:kind) >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    definitions.as(:definitions).maybe >>
    settings.as(:settings)
  }
  
  rule(:character_definitions) {
    character_definition.repeat(1)
  }
  
  # character_settings
  
  rule(:character_setting) {
    bra >> character_type.as(:kind) >> ket >> (
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
