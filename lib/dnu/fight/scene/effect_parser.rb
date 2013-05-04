# encoding: UTF-8
class EffectParser < Parslet::Parser
  
  # single character rules
  
  rule(:spaces) {
    match[' \t　'].repeat(1)
  }
  
  rule(:spaces?) {
    spaces.maybe
  }
  
  rule(:newline) {
    match['\r\n'].repeat(1)
  }
  
  rule(:num_1_to_9) {
    match['1-9１-９']
  }
  
  rule(:num_0_to_9) {
    match['0-9０-９']
  }
  
  rule(:color) {
    (
      match['0-9a-fA-F０-９ａ-ｆＡ-Ｆ'].repeat(6,6)
    ).as(:color_wrap)
  }
  
  rule(:bra) {
    spaces? >> match['(\[{（［｛「【'] >> spaces?
  }
  
  rule(:ket) {
    spaces? >> match[')\]}）］｝」】'] >> spaces?
  }
  
  rule(:at) {
    match['@＠']
  }
  
  rule(:separator) {
    spaces? >> match['|:/｜：／・'] >> spaces?
  }
  
  rule(:partition) {
    match['-'].repeat(1) >> newline
  }
  
  rule(:partition_end) {
    match['-'].repeat(1) >> newline.maybe
  }
  
  rule(:from_to) {
    match['~～'] | str('から')
  }
  
  rule(:dot) {
    match['.．']
  }
  
  rule(:plus) {
    spaces? >> match['+＋'] >> spaces?
  }
  
  rule(:minus) {
    spaces? >> match['-－'] >> spaces?
  }
  
  rule(:multiply) {
    spaces? >> match['*xX＊ｘＸ×'] >> spaces?
  }
  
  rule(:percent) {
    match['%％']
  }
  
  rule(:arrow) {
    spaces? >>
    (
      match['→⇒'] |
      match['=＝'] >> match['>＞']
    ) >>
    spaces?
  }
  
  rule(:op_gt) {
    spaces? >>
    match['>＞'] >>
    spaces?
  }
  
  rule(:op_lt) {
    spaces? >>
    match['<＜'] >>
    spaces?
  }
  
  rule(:op_ge) {
    spaces? >>
    (
      match['≧'] |
      match['>＞'] >> match['=＝']
    ) >>
    spaces?
  }
  
  rule(:op_le) {
    spaces? >>
    (
      match['≦'] |
      match['<＜'] >> match['=＝']
    ) >>
    spaces?
  }
  
  rule(:op_eq) {
    spaces? >>
    match['=＝'] >>
    spaces?
  }
  
  rule(:op_and) {
    spaces? >>
    (
      str('かつ') |
      str('に') |
      str('のとき') |
      str('and')
    ).maybe >>
    spaces?
  }
  
  rule(:op_or) {
    spaces? >>
    (
      str('または') | str('or')
    ) >>
    spaces?
  }
  
  rule(:comment) {
    str("#") >> (newline.absent? >> any).repeat(0) >> newline.maybe
  }
  
  rule(:excepts) {
    separator | arrow | plus | bra | ket | newline | multiply
  }
  
  rule(:alphabet) {
    match['A-ZＡ-Ｚ']
  }
  
  rule(:variable) {
    at >> bra >> (ket.absent? >> any).repeat(1).as(:name) >> ket >> spaces? |
    at >> (spaces.absent? >> any).repeat(1).as(:name) >> spaces |
    bra >> alphabet.as(:alphabet).as(:name) >> ket
  }
  
  rule(:coordinates) {
    alphabet.as(:alphabet_number).as(:x) >> natural_number.as(:y)
  }
  
  rule(:place) {
    (
      map_name.as(:name) >> spaces? >> coordinates
    ).as(:place)
  }
  
  rule(:eno_name) {
    match['eEｅＥ'] >> match['nNｎＮ'] >> match['oOｏＯ'] >> dot
  }
  
  rule(:eno) {
    eno_name >> natural_number.as(:eno)
  }
  
  rule(:string) {
    (
      str('"') >> 
      (
        str('\\') >> any |
        str('"').absent? >> any
      ).repeat.as(:inner_text) >> 
      str('"') >>
      newline.maybe
    ) |
    (
      partition >>
      (partition_end.absent? >> any).repeat(1).as(:inner_text) >>
      partition_end
    )
  }
  
  # name rule
  
  rule(:has_max) {
    (
      (
        alternation_from_array(GameData::BattleValue.has_max_and_equip_value(true, true)) |
        alternation_from_array(GameData::BattleValue.has_max_and_equip_value(true, false))
      ).as(:name)
    ).as(:battle_value_wrap).as(:battle_value)
  }
  
  rule(:battle_value) {
    (
      (
        str('最大').as(:max).maybe >>
        (
          str('能力') |
          str('装備')
        ).maybe.as(:status_or_equip) >>
        alternation_from_array(GameData::BattleValue.has_max_and_equip_value(true, true)).as(:name)
      ) |
      (
        str('最大').as(:max).maybe >>
        alternation_from_array(GameData::BattleValue.has_max_and_equip_value(true, false)).as(:name)
      ) |
      (
        (
          str('能力') |
          str('装備')
        ).maybe.as(:status_or_equip) >>
        alternation_from_array(GameData::BattleValue.has_max_and_equip_value(false, true)).as(:name)
      ) |
      alternation_from_array(GameData::BattleValue.has_max_and_equip_value(false, false)).as(:name)
    ).as(:battle_value_wrap).as(:battle_value)
  }
  
  rule(:status_name) {
    alternation_from_array(GameData::Status.pluck(:name))
  }
  
  rule(:disease_name) {
    dynamic{ |s,c|
      alternation_from_array(disease_list_temp)
    } |
    alternation_from_array(GameData::Disease.pluck(:name))
  }
  
  rule(:disease_value) {
    disease_name.as(:disease)
  }
  
  rule(:element_name) {
    alternation_from_array(GameData::Element.pluck(:name))
  }
  
  rule(:skill_name) {
    alternation_from_array(GameData::Skill.pluck(:name))
  }
  
  rule(:item_skill_name) {
    alternation_from_array(GameData::ItemSkill.pluck(:name))
  }
  
  rule(:item_use_name) {
    alternation_from_array(GameData::ItemUse.pluck(:name))
  }
  
  rule(:character_type) {
    alternation_from_array(GameData::CharacterType.pluck(:name))
  }
  
  rule(:landform_name) {
    alternation_from_array(GameData::Landform.pluck(:name))
  }
  
  rule(:map_name) {
    alternation_from_array(GameData::Map.pluck(:name))
  }
  
  rule(:equip_name) {
    alternation_from_array(GameData::Equip.pluck(:name))
  }
  
  rule(:art_name) {
    alternation_from_array(GameData::Art.pluck(:name))
  }
  
  rule(:item_type) {
    alternation_from_array(GameData::ItemType.pluck(:name))
  }
  
  rule(:equip_type) {
    alternation_from_array(GameData::EquipType.pluck(:name))
  }
  
  rule(:sup_name) {
    alternation_from_array(GameData::Sup.pluck(:name))
  }
  
  rule(:trap_name) {
    alternation_from_array(GameData::Trap.pluck(:name))
  }
  
  rule(:point_name) {
    alternation_from_array(GameData::Point.pluck(:name))
  }
  
  rule(:item_kind_and_name) {
    alternation_from_hash(GameData::Item.all.map{|r| { r.kind => r.name } })
  }
  
  rule(:art_kind_and_name) {
    alternation_from_hash(GameData::Art.all.map{|r| { r.kind => r.name } })
  }
  
  rule(:character_kind_and_name) {
    dynamic{ |s,c|
      alternation_from_hash(character_list_temp)
    } |
    alternation_from_hash(GameData::Character.all.map{|r| { r.kind => r.name } })
  }
  
  rule(:enemy_list_name) {
    alternation_from_array(GameData::EnemyList.pluck(:name))
  }
  
  # disease_name_set
  
  rule(:disease_name_complement) {
    (
      (
        disease_name_union |
        disease_name_set_warp
      ).as(:right) >>
      (
        str('を除く') |
        str('以外') >> str('の').maybe
      ) >>
      (
        disease_name_union |
        disease_name_set_warp
      ).as(:left)
    ).as(:disease_name_complement)
  }
  
  rule(:disease_name_union) {
    (
      disease_name_set_warp >> (match['&＆と'].maybe >> disease_name_set_warp).repeat(1)
    ).as(:disease_name_union)
  }
  
  rule(:disease_name_set_warp) {
    bra >> disease_name_set >> ket |
    disease_value
  }
  
  rule(:disease_name_set) {
    (
      disease_name_complement |
      disease_name_union |
      disease_name_set_warp
    ).as(:disease_name_set)
  }
  
  # target
  
  rule(:target_set_element) {
    str('敵').as(:target_other_team) |
    (str('味') >> str('方').maybe).as(:target_my_team) |
    (str('自') >> str('分').maybe).as(:target_active) |
    str('対象').as(:target_passive)
  }
  
  rule(:target_dependency_element) {
    character_type
  }
  
  rule(:target_live_or_dead) {
    (
      (
        (
          target_complement |
          target_dependency |
          target_union |
          target_set_warp
        ).as(:set) >>
        (
          str('生存').as(:live) |
          str('墓地').as(:dead)
        )
      ) |
      (
        (
          str('生存中').as(:live) |
          str('墓地中').as(:dead)
        ) >> str('の').maybe >>
        (
          target_complement |
          target_dependency |
          target_union |
          target_set_warp
        ).as(:set)
      )
    ).as(:target_live_or_dead)
  }
  
  rule(:target_complement) {
    (
      (
        target_dependency |
        target_union |
        target_set_warp
      ).as(:right) >>
      (
        str('を除く') |
        str('以外') >> str('の').maybe
      ) >>
      (
        target_dependency |
        target_union |
        target_set_warp
      ).as(:left)
    ).as(:target_complement)
  }
  
  rule(:target_dependency) {
    (
      (
        target_union |
        target_set_warp
      ).as(:master) >>
      str('の').maybe >> target_dependency_element.as(:kind)
    ).as(:target_dependency)
  }
  
  rule(:target_union) {
    (
      target_set_warp >> (str('と').maybe >> target_set_warp).repeat(1)
    ).as(:target_union)
  }
  
  rule(:target_set_warp) {
    bra >> target_set >> ket |
    target_set_element
  }
  
  rule(:target_set) {
    target_live_or_dead |
    target_complement |
    target_dependency |
    target_union |
    target_set_warp
  }
  
  rule(:target_find_single) {
    (
      str('から').maybe >> str('単') >> str('体').maybe
    ).as(:target_find_single)
  }
  
  rule(:target_find_random) {
    (
      str('から').maybe >> str('ラ') >> str('ンダム').maybe
    ).as(:target_find_random)
  }
  
  rule(:target_find_state) {
    (
      (
        str('高').as(:max) |
        str('低').as(:min)
      ).as(:target_condition) >>
      (
        battle_value >> str('割合').as(:ratio).maybe |
        disease_value
      ) >> str('追尾')
    ).as(:target_find_state)
  }
  
  rule(:target_find_all) {
    (
      str('の').maybe >> str('全') >> str('体').maybe
    ).maybe.as(:target_find_all)
  }
  
  rule(:target_find) {
    target_find_single |
    target_find_random |
    target_find_state |
    target_find_all
  }
  
  rule(:target) {
    (
      target_set.as(:set) >>
      target_find.as(:find)
    ).as(:target)
  }
  
  # effect_coeff
  
  rule(:level) {
    match['LＬ'] >> match['VＶ']
  }
  
  rule(:equip_strength) {
    str('装備強さ')
  }
  
  rule(:status_strength) {
    str('能力値')
  }
  
  rule(:distance) {
    str('対象') >> str('との距離')
  }
  
  rule(:calculable) {
    state |
    decimal.as(:fixnum) |
    level.as(:lv) |
    status_strength.as(:status_strength) |
    equip_strength.as(:equip_strength) |
    distance.as(:distance) |
    position_to_fixnum.as(:fixnum) |
    variable.as(:variable) |
    number_of_people.as(:number_of_people) |
    bra >> (
      random_number |
      add_coeff |
      diff_coeff |
      multi_coeff
    ) >> ket
  }
  
  rule(:number_of_people) {
    (
      str('PT').as(:party_members) |
      target_set
    ) >>
    str('人数')
  }
  
  rule(:random_number) {
    (
      (multi_coeff | calculable).as(:from) >> from_to >> (multi_coeff | calculable).as(:to)
    ).as(:random_number)
  }
  
  rule(:add_coeff) {
    (
      (
        diff_coeff |
        multi_coeff |
        calculable
      ) >>
      (
        plus >>
        (
          diff_coeff |
          multi_coeff |
          calculable
        )
      ).repeat(1)
    ).as(:add_coeff)
  }
  
  rule(:diff_coeff) {
    (
      (
        multi_coeff |
        calculable
      ) >>
      (
        minus >>
        (
          multi_coeff |
          calculable
        )
      ).repeat(1)
    ).as(:diff_coeff)
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
     random_number | add_coeff | diff_coeff | multi_coeff | calculable
  }
  
  # effect
  
  rule(:non_negative_integer) {
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
    match['SＳ'] >> match['WＷ'] >> str('物魔攻撃')
  }
  
  rule(:effect_hit) {
    str('命中').maybe   >> (non_negative_integer >> percent).as(:min_hit) >> (from_to >> (non_negative_integer >> percent).as(:max_hit)).maybe
  }
  
  rule(:effect_cri) {
    str('クリティカル').maybe >> (non_negative_integer >> percent).as(:min_cri) >> (from_to >> (non_negative_integer >> percent).as(:max_cri)).maybe
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
      has_max >> str('回復') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:heal)
  }
  
  rule(:change) {
    (
      battle_value >> str('増加') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:increase) |
    (
      battle_value >> str('減少') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:decrease) |
    (
      battle_value >> str('上昇') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:up) |
    (
      battle_value >> str('低下') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:down) |
    (
      disease_value >> str('軽減') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:reduce) |
    (
      battle_value >> str('奪取') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:steal) |
    (
      battle_value >> str('強奪') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:rob) |
    (
      battle_value >> str('変換') >> bra >> minus.as(:minus).maybe >> effect_coeff.as(:change_to) >> ket
    ).as(:convert) |
    (
      (bra >> str('技') >> ket >> ((str('消費増加') | excepts).absent? >> any).repeat(1).as(:name)).maybe >>
      str('消費増加') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost_up) |
    (
      (bra >> str('技') >> ket >> ((str('消費減少') | excepts).absent? >> any).repeat(1).as(:name)).maybe >>
      str('消費減少') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost_down)
  }
  
  rule(:disease) {
    (
      disease_value >> str('追加').maybe >> bra >> effect_coeff.as(:change_value) >> (separator >> effect_hit).maybe >> ket
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
          bra >> str('技') >> ket >> ((str('の設定') | excepts).absent? >> any).repeat(1).as(:name) >> str('の設定')
        ).as(:skill) |
        (
          str('付加').as(:this) |
          bra >> str('付加') >> ket >> ((str('全て') | str('消滅') | excepts).absent? >> any).repeat(1).as(:name) >> str('全て').as(:all).maybe
        ).as(:sup) |
        (
          str('一時効果').as(:this) |
          bra >> str('一時効果') >> ket >> ((str('全て') | str('消滅') | excepts).absent? >> any).repeat(1).as(:name) >> str('全て').as(:all).maybe
        ).as(:temporary_effect)
      ) >> str('消滅')
    ).as(:vanish)
  }
  
  rule(:change_setting) {
    (
      (
        (
          str('技設定を') |
          (
            bra >> str('技') >> ket >>
            ((str('の設定を') | excepts).absent? >> any).repeat(1).as(:name) >>
            str('の設定を')
          )
        ) >>
        (
          str('どれか').as(:random) |
          str('全て').as(:all)
        ).as(:find) >>
        bra >> (conditions | condition).as(:condition) >> ket >>
        str('に変更')
      ).as(:skill)
    ).as(:change_setting)
  }
  
  rule(:add_effects) {
    (
      (
        bra >> str('付加') >> ket >>
        sup_name.as(:name) >>
        (level >> natural_number.as(:lv)).maybe >>
        (bra >> str('重複不可').as(:unique) >> ket).maybe
      ).as(:sup) |
      (
        bra >> str('罠') >> ket >>
        trap_name.as(:name) >>
        (bra >> str('重複不可').as(:unique) >> ket).maybe
      ).as(:trap)
    ).as(:add_effects)
  }
  
  rule(:add_character) {
    (
      bra >> character_type.as(:kind) >> ket >>
      (excepts.absent? >> any).repeat(1).as(:name) >>
      (bra >> str('重複不可').as(:unique) >> ket).maybe
    ).as(:add_character)
  }
  
  rule(:add_double) {
    (
      bra >> str('分身') >> ket >>
      str('が出現') >>
      (bra >> str('重複不可') >> ket).maybe.as(:unique)
    ).as(:add_double)
  }
  
  rule(:cost) {
    (
      str('消費') >> bra >> effect_coeff.as(:change_value) >> ket
    ).as(:cost)
  }
  
  rule(:serif) {
    newline.maybe >> string.as(:serif)
  }
  
  rule(:revive) {
    (
      str('蘇生') >> bra >> effect_coeff.as(:change_to) >> (separator >> effect_hit).maybe >> ket
    ).as(:revive)
  }
  
  rule(:next_status) {
    (
      str('次の') >> state_target >> battle_value >> str('を') >> effect_coeff.as(:change_to) >> str('にする')
    ).as(:next_status)
  }
  
  rule(:next_turn) {
    (
      str('次のターン変化') >> bra >> newline.maybe >> root_processes >> ket
    ).as(:next_turn)
  }
  
  rule(:next_act) {
    (
      str('次の行動変化') >> bra >> newline.maybe >> root_processes >> ket
    ).as(:next_act)
  }
  
  rule(:next_add_act) {
    (
      str('次の追加行動変化') >> bra >> newline.maybe >> root_processes >> ket
    ).as(:next_add_act)
  }
  
  rule(:next_target_set) {
    target_set.as(:next_target_set)
  }
  
  rule(:next_target_sets) {
    str('次の対象範囲') >> bra >> (
      (
        next_target_set >> (separator >> next_target_set).repeat(1)
      ).as(:random) |
      next_target_set
    ) >> ket
  }
  
  rule(:next_target) {
    (
      str('次の対象') >> bra >> target >> ket
    ).as(:next_target)
  }
  
  rule(:next_attack_target) {
    (
      str('次の攻撃対象') >> bra >> target >> ket
    ).as(:next_attack_target)
  }
  
  rule(:add_reflection) {
    (
      attack_timing_options.as(:timing_transform).as(:timing) >>
      str('反射') >>
      bra >>
      effect_coeff.as(:repeat_value) >>
      (separator >> str('重複不可').as(:unique)).maybe >>
      ket
    ).as(:add_reflection)
  }
  
  rule(:nexts_coeff) {
    (
      effect_coeff.as(:coeff_value) >> percent >> (separator >> effect_coeff.as(:change_value)).maybe |
      effect_coeff.as(:change_value)
    )
  }
  
  rule(:add_next_damage) {
    (
      (str('次に与える') | str('次に受ける').as(:ant)) >>
      attack_timing_options.as(:timing_transform).as(:timing) >>
      str('ダメージ') >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      nexts_coeff >>
      (separator >> str('重複不可').as(:unique)).maybe >>
      ket
    ).as(:add_next_damage)
  }
  
  rule(:change_next_val) {
    (
      str('次の') >> str('被').as(:ant).maybe >>
      (
        str('ダメージ').as(:next_hit_val) |
        str('追加量').as(:next_add_val) |
        str('回復量').as(:next_heal_val) |
        str('増加量').as(:next_increase_val) |
        str('減少量').as(:next_decrease_val) |
        str('上昇量').as(:next_up_val) |
        str('低下量').as(:next_down_val) |
        str('奪取量').as(:next_steal_val) |
        str('強奪量').as(:next_rob_val) |
        str('軽減量').as(:next_reduce_val) |
        str('消費量').as(:next_cost_val) |
        str('変換量').as(:next_convert_val)
      ).as(:change_next_type) >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      nexts_coeff >>
      ket
    ).as(:change_next_val)
  }
  
  rule(:add_next_hitrate) {
    (
      str('次の') >>
      attack_timing_options.as(:timing_transform).as(:timing) >> str('攻撃の') >>
      (
        str('回避率').as(:ant) | str('命中率')
      ) >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      nexts_coeff >>
      (separator >> str('重複不可').as(:unique)).maybe >>
      ket
    ).as(:add_next_hitrate)
  }
  
  rule(:next_hitrate) {
    (
      str('次の') >>
      (
        str('回避率').as(:ant) | str('命中率')
      ) >>
      (str('増加') | str('減少').as(:minus)) >>
      bra >>
      nexts_coeff >>
      ket
    ).as(:next_hitrate)
  }
  
  rule(:add_disease_protect) {
    (
      disease_value >> str('防御') >> bra >>
      effect_coeff.as(:repeat_value) >>
      (separator >> str('重複不可').as(:unique)).maybe >>
      ket
    ).as(:add_disease_protect)
  }
  
  rule(:add_next_attack_element) {
    (
      str('次の') >> effect_coeff.as(:repeat_value) >> str('回分の攻撃が') >> element_name.as(:element) >> str('属性化') >> (bra >> str('重複不可').as(:unique) >> ket).maybe
    ).as(:add_next_attack_element)
  }
  
  rule(:next_attack_element) {
    (
      str('次の攻撃属性') >> element_name.as(:element)
    ).as(:next_attack_element)
  }
  
  rule(:effect) {
    (
      (
        heal |
        change |
        cost |
        next_status |
        next_turn |
        next_act |
        next_add_act |
        next_target_sets |
        next_target |
        next_attack_target |
        change_next_val |
        next_hitrate |
        next_attack_element |
        serif
      ) >> arrow.absent? |
      attack |
      revive |
      disease |
      vanish |
      change_setting |
      add_next_damage |
      add_next_hitrate |
      add_disease_protect |
      add_next_attack_element |
      add_effects |
      add_character |
      add_double |
      add_reflection |
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
    target_set.as(:group)
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
        (disease_value.maybe >> str('追加量')).as(:disease) |
        (battle_value.maybe  >> str('回復量')).as(:heal) |
        (battle_value.maybe  >> str('上昇量')).as(:up) |
        (battle_value.maybe  >> str('低下量')).as(:down) |
        (battle_value.maybe  >> str('増加量')).as(:increase) |
        (battle_value.maybe  >> str('減少量')).as(:decrease) |
        (disease_value.maybe >> str('軽減量')).as(:reduce) |
        (battle_value.maybe  >> str('奪取量')).as(:steal) |
        (battle_value.maybe  >> str('強奪量')).as(:rob) |
        (battle_value.maybe  >> str('変換量')).as(:convert) |
        str('消費量').as(:cost)
      )
    ).as(:state_effects_just_before_change) |
    (
      str('直後') >> (
        str('ダメージ').as(:attack) |
        (disease_value.maybe >> str('追加量')).as(:disease) |
        (battle_value.maybe  >> str('回復量')).as(:heal) |
        (battle_value.maybe  >> str('上昇量')).as(:up) |
        (battle_value.maybe  >> str('低下量')).as(:down) |
        (battle_value.maybe  >> str('増加量')).as(:increase) |
        (battle_value.maybe  >> str('減少量')).as(:decrease) |
        (disease_value.maybe >> str('軽減量')).as(:reduce) |
        (battle_value.maybe  >> str('奪取量')).as(:steal) |
        (battle_value.maybe  >> str('強奪量')).as(:rob) |
        (battle_value.maybe  >> str('変換量')).as(:convert) |
        str('消費量').as(:cost)
      )
    ).as(:state_effects_just_after_change) |
    (
      (
        str('ダメージ').as(:attack) |
        (disease_value.maybe >> str('追加')).as(:disease) |
        (battle_value.maybe  >> str('回復')).as(:heal) |
        (battle_value.maybe  >> str('上昇')).as(:up) |
        (battle_value.maybe  >> str('低下')).as(:down) |
        (battle_value.maybe  >> str('増加')).as(:increase) |
        (battle_value.maybe  >> str('減少')).as(:decrease) |
        (disease_value.maybe >> str('軽減')).as(:reduce) |
        (battle_value.maybe  >> str('奪取')).as(:steal) |
        (battle_value.maybe  >> str('強奪')).as(:rob) |
        (battle_value.maybe  >> str('変換')).as(:convert) |
        str('消費').as(:cost)
      ).as(:scene) >>
      (
        str('合計').as(:sum) |
        str('回数').as(:count)
      ).as(:type)
    ).as(:state_effects_change) |
    (
      (
        (
          bra >> str('技')   >> ket >> ((str('発動回数') | excepts).absent? >> any).repeat(1).as(:name)
        ).as(:skill) |
        (
          bra >> str('付加') >> ket >> ((str('発動回数') | excepts).absent? >> any).repeat(1).as(:name)
        ).as(:sup)
      ).maybe >> str('発動回数')
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
      state_target       >> battle_value >> (str('の') >> non_negative_integer.as(:percent) >> percent | str('割合').as(:ratio)).maybe |
      state_target_group >> battle_value >> (str('の') >> non_negative_integer.as(:percent) >> percent | str('割合').as(:ratio)).maybe >> group_value
    ).as(:state_character)
  }
  
  rule(:state_disease) {
    (
      state_target       >> disease_value >> str('深度') |
      state_target_group >> disease_value >> str('深度') >> group_value
    ).as(:state_disease)
  }
  
  rule(:has_max_percent) {
    (
      (
        (
          (
            state_target       >> has_max |
            state_target_group >> has_max >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            has_max.as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        calculable.as(:percent).as(:fixnum).as(:right) >>
        percent >> str('以上')
      ).as(:condition_ge) |
      (
        (
          (
            state_target       >> has_max |
            state_target_group >> has_max >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            has_max.as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        calculable.as(:percent).as(:fixnum).as(:right) >>
        percent >> str('以下')
      ).as(:condition_le) |
      (
        (
          (
            state_target       >> has_max |
            state_target_group >> has_max >> group_value
          ).as(:state_character).as(:left) |
          (
            state_target_group >>
            has_max.as(:state_character).as(:do)
          ).as(:lefts)
        ) >>
        calculable.as(:percent).as(:fixnum).as(:right) >>
        percent
      ).as(:condition_eq)
    ).as(:has_max_percent)
  }
  
  rule(:random_percent) {
    (
      (
        non_negative_integer.as(:fixnum) |
        bra >> effect_coeff >> ket
      ) >> percent >> str('の確率').maybe
    ).as(:random_percent)
  }
  
  rule(:wrap_random_percent) {
    (
      str('頻度') >> match['1-5１-５'].as(:number).as(:frequency) |
      str('通常時').as(:normal)
    ).as(:wrap_random_percent)
  }
  
  rule(:act_count) {
    str('第') >> calculable.as(:act_count) >> str('行動') >> str('時').maybe
  }
  
  rule(:next_not_change) {
    (
      state_target >>
      str('次の') >>
      (
        str('ターン').as(:turn) |
        str('行動').as(:act) |
        str('追加行動').as(:add_act) |
        str('対象範囲').as(:target_set) |
        str('対象').as(:target) |
        str('攻撃対象').as(:attack_target) |
        str('攻撃属性').as(:attack_element) |
        str('命中率').as(:hitrate) |
        str('回避率').as(:hitrate_ant) |
        str('ダメージ').as(:hit_val) |
        str('被ダメージ').as(:hit_val_ant) |
        str('追加量').as(:add_val) |
        str('被追加量').as(:add_val_ant) |
        str('回復量').as(:heal_val) |
        str('被回復量').as(:heal_val_ant) |
        str('増加量').as(:increase_val) |
        str('被増加量').as(:increase_val_ant) |
        str('減少量').as(:decrease_val) |
        str('被減少量').as(:decrease_val_ant) |
        str('上昇量').as(:up_val) |
        str('被上昇量').as(:up_val_ant) |
        str('低下量').as(:down_val) |
        str('被低下量').as(:down_val_ant) |
        str('奪取量').as(:steal_val) |
        str('被奪取量').as(:steal_val_ant) |
        str('強奪量').as(:rob_val) |
        str('被強奪量').as(:rob_val_ant) |
        str('軽減量').as(:reduce_val) |
        str('被軽減量').as(:reduce_val_ant) |
        str('消費量').as(:cost_val) |
        str('被消費量').as(:cost_val_ant) |
        str('変換量').as(:convert_val) |
        str('被変換量').as(:convert_val_ant)
      ).as(:nexts) >> str('未変化')
    ).as(:next_not_change)
  }
  
  rule(:in_pre_phase) {
    str('非接触フェイズ').as(:in_pre_phase)
  }
  
  rule(:in_phase) {
    str('通常フェイズ').as(:in_phase)
  }
  
  rule(:condition_boolean) {
    (
      (
        just_before |
        random_percent |
        wrap_random_percent |
        next_not_change |
        in_pre_phase |
        in_phase |
        act_count |
        present_place |
        get_flag
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
        battle_value >> (
          str('の') >> non_negative_integer.as(:percent) >> percent |
          str('割合').as(:ratio)
        ).maybe
      ).as(:state_character).as(:do) |
      disease_value.as(:state_disease).as(:do) >> str('深度')
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
  
  rule(:condition_gt) {
    (
      comparable_left >> str('が').maybe >> comparable_right >> str('より大きい') |
      comparable_left >> op_gt >> comparable_right
    ).as(:condition_gt)
  }
  
  rule(:condition_lt) {
    (
      comparable_left >> str('が').maybe >> comparable_right >> str('より小さい') |
      comparable_left >> op_lt >> comparable_right
    ).as(:condition_lt)
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
    has_max_percent |
    condition_ge |
    condition_le |
    condition_gt |
    condition_lt |
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
      target >> (separator | bra.present?) >> process.as(:do)
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
        (effect_condition.maybe >> target).present? >> process_wrap >> newline.maybe
      ).repeat(2)
    ).as(:sequence) |
    (effect_condition.maybe >> target).present? >> process_wrap >> newline.maybe
  }
  
  # sup_effects
  
  rule(:before_after) {
    str('前').as(:before) |
    str('後').as(:after)
  }
  
  rule(:priority) {
    str('優先度') >> natural_number.as(:priority)
  }
  
  rule(:pre_phase) {
    str('非接触').as(:pre_phase)
  }
  
  rule(:attack_timing_options) {
    (element_name.as(:element) >> str('属性')).maybe >>
    (str('物理').as(:physical) | str('魔法').as(:magical)).maybe
  }
  
  rule(:disease_timing_options) {
    disease_value.maybe
  }
  
  rule(:heal_timing_options) {
    (
      str('HP').as(:HP) |
      str('MP').as(:MP)
    ).maybe
  }
  
  rule(:status_timing_options) {
    battle_value.maybe
  }
  
  rule(:timing) {
    (
      str('戦闘').as(:battle) |
      str('フェイズ').as(:phase) |
      str('ターン').as(:turn) |
      str('行動').as(:act) |
      str('追加行動').as(:add_act) |
      str('通常攻撃').as(:default_attack) |
      str('特殊効果').as(:effects) |
      str('対象決定').as(:root) |
      attack_timing_options >> (
        str('攻撃命中').as(:hit) |
        str('攻撃被弾').as(:hit_ant) |
        str('クリティカル').as(:critical) |
        str('被クリティカル').as(:critical_ant) |
        str('攻撃空振').as(:miss) |
        str('攻撃回避').as(:miss_ant) |
        str('攻撃').as(:attack) |
        str('被攻撃').as(:attack_ant) |
        str('ダメージ決定').as(:hit_val) |
        str('被ダメージ決定').as(:hit_val_ant) |
        str('命中率決定').as(:hitrate) |
        str('回避率決定').as(:hitrate_ant)
      ) |
      status_timing_options >> (
        str('増加量決定').as(:increase_val) |
        str('被増加量決定').as(:increase_val_ant) |
        str('減少量決定').as(:decrease_val) |
        str('被減少量決定').as(:decrease_val_ant) |
        str('上昇量決定').as(:up_val) |
        str('被上昇量決定').as(:up_val_ant) |
        str('低下量決定').as(:down_val) |
        str('被低下量決定').as(:down_val_ant) |
        str('奪取量決定').as(:steal_val) |
        str('被奪取量決定').as(:steal_val_ant) |
        str('強奪量決定').as(:rob_val) |
        str('被強奪量決定').as(:rob_val_ant) |
        str('変換量決定').as(:convert_val) |
        str('被変換量決定').as(:convert_val_ant)
      ) |
      str('消費量決定').as(:cost_val) |
      str('被消費量決定').as(:cost_val_ant) |
      disease_timing_options >> (
        str('軽減量決定').as(:reduce_val) |
        str('被軽減量決定').as(:reduce_val_ant) |
        str('追加量決定').as(:add_val) |
        str('被追加量決定').as(:add_val_ant)
      ) |
      heal_timing_options >> (
        str('回復量決定').as(:heal_val) |
        str('被回復量決定').as(:heal_val_ant)
      ) |
      str('墓地埋葬').as(:cemetery)
    ).as(:timing_transform).as(:timing) >> before_after.as(:before_after) |
    (
      str('戦闘値決定時').as(:battle_val)
    ).as(:timing)
  }
  
  rule(:sup_effect) {
    bra >> timing >> ket >>
    (priority >> separator).maybe >>
    (
      (conditions | condition).as(:condition) >> newline |
      newline.as(:condition_default).as(:condition)
    ) >> root_processes.as(:do)
  }
  
  rule(:sup_effects) {
    sup_effect.repeat(0)
  }
  
  # learning_conditions
  
  rule(:learning_condition) {
    art_name.as(:name) >> level >> natural_number.as(:lv)
  }
  
  rule(:learning_condition_wrap) {
    learning_or |
    learning_and |
    learning_condition
  }
  
  rule(:learning_or) {
    (
      (learning_and | learning_condition) >>
      (
        (op_or | separator) >>
        (learning_and | learning_condition)
      ).repeat(1)
    ).as(:or)
  }
  
  rule(:learning_and) {
    (
      learning_condition.repeat(2)
    ).as(:and)
  }
  
  rule(:learning_conditions) {
    (
      learning_condition_wrap >> newline.maybe
    ).as(:learning_conditions)
  }
  
  # sup_definition
  
  rule(:sup_definition) {
    bra >> str('付加') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # trap_definition
  
  rule(:trap_definition) {
    bra >> str('罠') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # default_attack_definition
  
  rule(:default_attack_definition) {
    bra >> str('通常攻撃') >> ket >> newline >>
    root_processes.as(:do).repeat(1).as(:effects)
  }
  
  # equip_definition
  
  rule(:equip_definition) {
    bra >> equip_type.as(:kind) >> ket >>
    (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    string.as(:caption).maybe >>
    sup_effects.as(:effects) >>
    (default_attack_definition.as(:default_attack)).maybe
  }
  
  # status_definition
  
  rule(:status_definition) {
    bra >> str('能力') >> ket >>
    (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    partition >> (partition.absent? >> any).repeat(1).as(:caption) >> partition >>
    sup_effects.as(:effects)
  }
  
  # temporary_effect_definition
  
  rule(:temporary_effect_definition) {
    bra >> str('一時効果') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    sup_effects.as(:effects)
  }
  
  # disease_definition
  
  rule(:disease_definition) {
    bra >> str('状態異常') >> ket >> (separator.absent? >> any).repeat(1).capture(:name).as(:name) >> separator >> color.as(:color) >> newline >>
    dynamic{ |s,c|
      disease_list_temp.push(c.captures[:name].to_s)
      any.present?
    } >>
    partition >> (partition.absent? >> any).repeat(1).as(:caption) >> partition >>
    sup_effects.as(:effects) >>
    dynamic{ |s,c|
      disease_list_temp.clear
      any.present? | any.absent?
    }
  }
  
  # skill_definition
  
  rule(:pre_phasable) {
    str('遠')
  }
  
  rule(:targetable) {
    str('対')
  }
  
  rule(:skill_options) {
    separator >> non_negative_integer.as(:cost) >>
    (separator >> equip_name.as(:require)).maybe >>
    (separator >> pre_phasable.as(:pre_phasable)).maybe >>
    (separator >> targetable.as(:targetable)).maybe >> newline
  }
  
  rule(:skill_definition) {
    bra >> str('技') >> ket >> ((skill_options | newline).absent? >> any).repeat(1).as(:name) >> skill_options >>
    learning_conditions.maybe >>
    (
      partition >>
      (
        sup_definition.as(:sup) |
        trap_definition.as(:trap)
      ).repeat(1).as(:definitions) >>
      partition
    ).maybe >>
    root_processes.as(:do).repeat(1).as(:effects)
  }
  
  # item_skill_definition
  
  rule(:item_skill_definition) {
    bra >> str('戦物') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    (
      partition >>
      (
        sup_definition.as(:sup) |
        trap_definition.as(:trap)
      ).repeat(1).as(:definitions) >>
      partition
    ).maybe >>
    root_processes.as(:do).repeat(1).as(:effects)
  }
  
  # forge
  
  rule(:forge) {
    bra >> str('作製') >> ket >>
    (item_type.as(:item_type) >> separator.maybe).repeat(1).as(:forgeable_item_types_wrap).as(:forgeable_item_types) >>
    (natural_number >> str('枠')).maybe.as(:forgeable_number_wrap).as(:forgeable_number) >> newline.maybe
  }
  
  # art_effect_definition
  
  rule(:lv_effects) {
    level >> natural_number.as(:lv) >> separator >> (newline.absent? >> any).repeat(1).as(:caption) >> newline >>
    sup_effects.as(:effects)
  }
  
  rule(:pull_down_effects) {
    str('プルダウン') >> level >> natural_number.as(:lv) >> separator >> (newline.absent? >> any).repeat(1).as(:pull_down) >> newline >>
    sup_effects.as(:effects)
  }
  
  rule(:art_effect_definition) {
    art_kind_and_name >> newline >>
    learning_conditions.maybe >>
    forge.maybe >>
    sup_effects.as(:effects) >>
    (
      lv_effects |
      pull_down_effects
    ).repeat(0).as(:definitions)
  }
  
  # definitions
  
  rule(:definitions) {
    (
      comment |
      art_effect_definition.as(:art) |
      sup_definition.as(:sup) |
      disease_definition.as(:disease) |
      skill_definition.as(:skill)
    ).repeat(1)
  }
  
  # sup_setting
  
  rule(:sup_setting) {
    bra >> str('付加') >> ket >> sup_name.as(:name) >> (
      level >> natural_number.as(:lv)
    ).maybe >> newline.maybe
  }
  
  # equip_setting
  
  rule(:equip_setting) {
    bra >> equip_type.as(:kind) >> ket >> equip_name.as(:name) >> spaces? >>
    (
      natural_number.as(:equip_strength) |
      str('比率') >> decimal.as(:equip_rate)
    ) >> newline.maybe >>
    sup_setting.as(:sup).repeat(0).as(:settings)
  }
  
  # drop_setting
  
  rule(:drop_setting) {
    item_kind_and_name >> spaces? >> natural_number >> percent >> newline.maybe
  }
  
  # point_setting
  
  rule(:point_setting) {
    bra >> str('ポイント') >> ket >> point_name >> correction.as(:correction) >> newline.maybe
  }
  
  # status_setting
  
  rule(:status_setting) {
    bra >> str('能力') >> ket >> status_name.as(:name) >> spaces? >>
    (
      natural_number.as(:status_strength) |
      str('比率') >> decimal.as(:status_rate)
    ) >> newline.maybe
  }
  
  # skill_setting
  
  rule(:position_to_fixnum) {
    (str('前') | str('中') | str('後')).as(:position_to_fixnum)
  }
  
  rule(:skill_target) {
    (str('上から') >> calculable.as(:number) >> str('番目')).as(:find_by_number) |
    (calculable.as(:position) >> str('列')).as(:find_by_position) |
    (eno_name >> calculable.as(:eno)).as(:find_by_eno)
  }
  
  rule(:skill_condition) {
    (
      pre_phase.as(:timing) |
      str('必殺技').as(:special)
    ).maybe >> spaces? >>
    (
      conditions |
      condition |
      (
        any.present? |
        any.absent?
      ).as(:condition_default)
    ).as(:condition) >>
    (
      (newline | separator).maybe >> str('対象').maybe >> separator.maybe >> skill_target.as(:target)
    ).maybe
  }
  
  rule(:skill_setting) {
    bra >> str('技') >> ket >> skill_name.as(:name) >> (
      level >> natural_number.as(:lv)
    ).maybe >> newline >>
    priority >> separator >> skill_condition >>
    (
      newline >> root_processes.as(:serif)
    ).maybe >> newline.maybe
  }
  
  # item_skill_setting
  
  rule(:item_skill_setting) {
    bra >> str('戦物') >> ket >> item_skill_name.as(:name) >> newline >>
    priority >> separator >> skill_condition >>
    (
      newline >> root_processes.as(:serif)
    ).maybe >> newline.maybe
  }
  
  # serif_setting
  
  rule(:serif_setting) {
    bra >> str('セリフ') >> ket >> newline >>
    sup_effects.as(:effects)
  }
  
  # art_setting
  
  rule(:art_setting) {
    art_kind_and_name >>
    level >> natural_number.as(:lv) >> newline.maybe
  }
  
  # settings
  
  rule(:settings) {
    (
      comment |
      art_setting.as(:art) |
      status_setting.as(:status) |
      equip_setting.as(:equip) |
      sup_setting.as(:sup) |
      skill_setting.as(:skill) |
      item_skill_setting.as(:item_skill) |
      serif_setting.as(:serif) |
      drop_setting.as(:drop) |
      point_setting.as(:point)
    ).repeat(0)
  }
  
  # character_definitions
  
  rule(:rank) {
    separator >> str('ランク').maybe >> spaces? >> natural_number.as(:rank)
  }
  
  rule(:character_definition) {
    bra >> character_type.capture(:kind).as(:kind) >> ket >> (separator.absent? >> any).repeat(1).capture(:name).as(:name) >>
    dynamic{ |s,c|
      character_list_temp.push(c.captures[:kind].to_s => c.captures[:name].to_s)
      any.present?
    } >> rank >> (newline | any.absent?) >>
    definitions.as(:definitions).maybe >>
    settings.as(:settings)
  }
  
  rule(:character_definitions) {
    character_definition.repeat(1)
  }
  
  # character_setting
  
  rule(:correction) {
    (
      spaces? >>
      (plus | minus.as(:minus)) >>
      natural_number.as(:value)
    ).as(:correction_wrap)
  }
  
  rule(:character_setting) {
    character_kind_and_name >>
    correction.as(:correction).maybe
  }
  
  # pt_settings
  
  rule(:character_pc) {
    bra >> str('PC').as(:kind) >> ket >> eno >> (spaces? >> str('第') >> natural_number.as(:correction) >> str('回')).maybe
  }
  
  rule(:pt_definition) {
    bra >> str('PT') >> ket >> (newline.absent? >> any).repeat(1).as(:pt_name) >> newline >>
    string.as(:pt_caption).maybe >>
    (
      (
        character_setting |
        character_pc
      ) >>
      (
        multiply >> calculable.as(:number)
      ).maybe >>
      (newline | any.absent?)
    ).repeat(1).as(:members)
  }
  
  rule(:pt_settings) {
    character_definitions.as(:definitions).maybe >>
    pt_definition.repeat(1).as(:settings) >>
    dynamic{ |s,c|
      character_list_temp.clear
      any.present? | any.absent?
    }
  }
  
  # event_timing
  
  rule(:event_timing) {
    (
      str('移動毎').as(:each_move) |
      str('移動後').as(:after_move)
    ).as(:timing)
  }
  
  # event_condition
  
  rule(:on) {
    str('オン') | str('済') | str('達成')
  }
  
  rule(:off) {
    str('オフ') | str('未達成')
  }
  
  rule(:present_place) {
    (str('現在地') >> str('が').maybe >> spaces?).maybe >> place.as(:present_place)
  }
  
  rule(:get_flag) {
    (
      variable >>
      (
        on.as(:on) |
        off.as(:off)
      )
    ).as(:get_flag)
  }
  
  rule(:event_condition) {
    (conditions | condition).as(:condition)
  }
  
  # event_contents
  
  rule(:print_text) {
    string.as(:print_text)
  }
  
  rule(:set_flag) {
    (
      variable >> str('を').maybe >>
      (
        on.as(:on) |
        off.as(:off)
      )
    ).as(:boolean).as(:set_flag)
  }
  
  rule(:set_integer) {
    (
      variable >> str('を').maybe >>
      (plus.as(:plus) | minus.as(:minus)).maybe >>
      non_negative_integer.as(:integer) >> str('に').maybe
    ).as(:integer).as(:set_integer)
  }
  
  rule(:change_place) {
    place.as(:change_place) >> spaces? >> str('に移動')
  }
  
  rule(:end_step) {
    (str('この') >> (str('イベント') | str('ステップ')).present?).maybe >> (str('イベント') >> str('ステップ').present?).maybe >> str('ステップ').maybe >> str('終了').as(:end_step)
  }
  
  rule(:end_event) {
    str('この').maybe >> str('イベント終了').as(:end_event)
  }
  
  rule(:add_event) {
    (
      bra >> event_kind.as(:kind) >> str('イベント') >> ket >>
      (spaces.absent? >> any).repeat(1).as(:name) >> spaces >>
      str('を').maybe >> str('追加')
    ).as(:add_event)
  }
  
  rule(:add_item) {
    (
      item_kind_and_name >> spaces? >>
      str('を').maybe >> str('追加')
    ).as(:add_item)
  }
  
  rule(:purchase) {
    (
      item_kind_and_name >> spaces? >>
      non_negative_integer.as(:price) >> point_name.as(:point) >> newline.maybe
    ).repeat(1).as(:purchase)
  }
  
  rule(:add_pet) {
    (
      character_kind_and_name >>
      correction.as(:correction).maybe >>
      spaces? >>
      str('を').maybe >> str('追加')
    ).as(:add_pet)
  }
  
  rule(:catch_pet) {
    bra >> str('捕獲') >> ket >> newline.maybe >>
    (
      character_kind_and_name >>
      correction.as(:correction).maybe >>
      (separator | newline).maybe
    ).repeat(1).as(:catch_pet)
  }
  
  rule(:add_notice) {
    pt_definition.as(:add_notice)
  }
  
  rule(:event_content) {
    print_text |
    set_flag |
    set_integer |
    add_event |
    add_item |
    purchase |
    add_pet |
    catch_pet |
    add_notice |
    change_place |
    end_step |
    end_event
  }
  
  rule(:event_separator) {
    newline | plus | arrow
  }
  
  rule(:event_contents) {
    (
      event_separator.absent? >> (event_separator.maybe >> event_content).repeat(1)
      #event_content >> (event_separator >> event_content).repeat(0)
    ).as(:contents)
  }
  
  # event_steps
  
  rule(:event_step_name) {
    (
      dynamic{ |s,c|
        alternation_from_array(event_step_list_temp)
      } >> newline
    ).absent? >> (newline .absent? >> any).repeat(1)
  }
  
  rule(:event_step) {
    (
      bra >> str('ステップ') >> ket >> event_step_name.capture(:name).as(:name) >> newline >>
      dynamic{ |s,c|
        event_step_list_temp.push(c.captures[:name].to_s)
        any.present?
      }
    ).maybe >>
    bra >> event_timing >> ket >> event_condition >> newline >>
    event_contents >> newline.maybe
  }
  
  rule(:event_steps) {
    event_step.repeat(1).as(:steps)
  }
  
  # event_definition
  
  rule(:event_kind) {
    str('共通') |
    str('内部') |
    str('通常').maybe
  }
  
  rule(:event_definition) {
    bra >> event_kind.as(:kind) >> str('イベント') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    string.as(:caption).maybe >>
    event_steps >>
    dynamic{ |s,c|
      event_step_list_temp.clear
      any.present? | any.absent?
    }
  }
  
  # item_use_definition
  
  rule(:item_use_definition) {
    bra >> str('使用') >> ket >> (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    event_contents
  }
  
  # item_definition
  
  rule(:item_sup) {
    (separator | newline).maybe >>
    (bra >> element_name.as(:element) >> ket).maybe >>
    (
      sup_name.as(:name) >> (
        level >> natural_number.as(:lv)
      ).maybe
    ).as(:sup) >>
    (
      plus >>
      sup_name.as(:name) >> (
        level >> natural_number.as(:lv)
      ).maybe
    ).as(:G).maybe >>
    bra >>
    (
      equip_type.as(:equip_type) >>
      (
        level.maybe >>
        natural_number.as(:lv)
      ).maybe
    ) >>
    ket >>
    (separator | newline).maybe
  }
  
  rule(:item_skill) {
    bra >> str('戦物') >> ket >> item_skill_name.as(:name)
  }
  
  rule(:item_use) {
    bra >> str('使用') >> ket >> item_use_name.as(:name)
  }
  
  rule(:item_definition) {
    (newline.absent? >> any).repeat(1).as(:name) >> newline >>
    spaces? >> (bra >> element_name.as(:element) >> ket).maybe >>
    bra >> item_type.as(:kind) >>
    separator >> non_negative_integer.as(:strength) >>
    separator >> (
      minus |
      (
        sup_name.as(:name) >> (
          level >> natural_number.as(:lv)
        ).maybe
      ).as(:A)
    ) >>
    (
      plus >>
      sup_name.as(:name) >> (
        level >> natural_number.as(:lv)
      ).maybe
    ).as(:G).maybe >>
    separator >> (
      minus |
      (
        sup_name.as(:name) >> (
          level >> natural_number.as(:lv)
        ).maybe
      ).as(:B)
    ) >>
    ket >>
    (bra >> str('破棄').as(:dispose_protect).maybe >> str('送品').as(:send_protect).maybe >> str('不可') >> ket).maybe >>
    newline.maybe >>
    string.as(:caption).maybe >>
    item_sup.repeat(0).as(:item_sups) >>
    item_skill.maybe.as(:item_skill) >> newline.maybe >>
    item_use.maybe.as(:item_use) >> newline.maybe
  }
  
  # enemy_list_definition
  
  rule(:enemy_list_definition) {
    bra >> str('敵リスト') >> ket >>
    (newline.absent? >> any).repeat(1).as(:name) >> newline.present? >>
    (
      newline >>
      character_setting >>
      (
        spaces? >> str('出現倍率') >> decimal.as(:frequency)
      ).maybe
    ).repeat(1).as(:list) >>
    newline.maybe
  }
  
  # enemy_list_setting
  
  rule(:enemy_list_setting) {
    bra >> str('敵リスト') >> ket >>
    enemy_list_name.as(:name) >>
    correction.as(:correction).maybe
  }
  
  # enemy_territory_definition
  
  rule(:enemy_territory_definition) {
    (
      landform_name.as(:landform) |
      map_name.as(:map_name) >> spaces? >>
      (
        landform_name.as(:landform) |
        coordinates.as(:coordinates)
      ).maybe
    ) >>
    arrow >>
    enemy_list_setting >>
    newline.maybe
  }
  
  # root
  
  root(:root_processes)
  
  private
  def event_step_list_temp
    @event_step_list_temp ||= []
    @event_step_list_temp
  end
  
  def disease_list_temp
    @disease_list_temp ||= []
    @disease_list_temp
  end
  
  def character_list_temp
    @character_list_temp ||= []
    @character_list_temp
  end
  
  def alternation_from_array(words)
    result = nil
    
    words.uniq!
    words.sort!{|a,b| b.size <=> a.size}
    
    words.each do |word|
      if result.nil?
        result = str(word)
      else
        result = result | str(word)
      end
    end
    
    result ||= any.absent? >> any
    
    result
  end
  
  def alternation_from_hash(words)
    result = nil
    
    words.sort!{|a,b| b.values.first.size <=> a.values.first.size}
    
    words.each do |h|
      kind = h.keys.first
      name = h.values.first
      if result.nil?
        result = bra >> str(kind).as(:kind) >> ket >> str(name).as(:name)
      else
        result = result | bra >> str(kind).as(:kind) >> ket >> str(name).as(:name)
      end
    end
    
    result ||= any.absent? >> any
    
    result
  end
end
