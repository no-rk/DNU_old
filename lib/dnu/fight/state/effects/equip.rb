# encoding: UTF-8
module DNU
  module Fight
    module State
      class Equip < BaseEffects
        
        attr_reader :kind, :range, :equip_strength, :default_attack
        
        def when_initialize(tree)
          @kind  = tree[:kind].to_sym
          @range = tree[:range].to_i
          @equip_strength = tree[:equip_strength].to_i
          @default_attack = DNU::Fight::State::DefaultAttack.new(tree[:default_attack]).first unless tree[:default_attack].nil?
          tree[:settings].try(:each) do |setting|
            parent.add_effects(setting, self, tree[:definitions])
          end
        end
        
      end
    end
  end
end
