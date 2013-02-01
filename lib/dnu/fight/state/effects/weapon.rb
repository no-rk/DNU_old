# encoding: UTF-8
module DNU
  module Fight
    module State
      class Weapon < BaseEffects
        
        attr_reader :range, :equip_strength, :default_attack
        
        def when_initialize(tree)
          @range = tree[:range].to_i
          @equip_strength = tree[:equip_strength].to_i
          @default_attack = DNU::Fight::State::DefaultAttack.new(tree[:default_attack]).first unless tree[:default_attack].nil?
          tree[:settings].try(:each) do |setting|
            parent.add_effects(setting.keys.first, setting.values.first[:name], setting.values.first, tree[:definitions], self)
          end
        end
        
      end
    end
  end
end
