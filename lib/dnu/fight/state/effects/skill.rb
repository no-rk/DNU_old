# encoding: UTF-8
module DNU
  module Fight
    module State
      class Skill < BaseEffects
        
        def cost_effects
          EffectTransform.new.apply(EffectParser.new.root_processes.parse("自/消費(#{cost})"))
        end
        
        attr_reader :cost, :require, :pre_phase, :targetable
        
        def when_initialize(tree)
          @cost       = tree[:cost]
          @require    = tree[:require]
          @pre_phase  = tree[:pre_phase]
          @targetable = tree[:targetable]
          tree[:effects].each do |effect|
            effect[:priority]  = tree[:priority]
            effect[:condition] = {
              :condition_and => {
                :left  => {
                  :condition_ge => {
                    :left  => { :state_character => { :state_target=> "自分", :status_name=> "MP" } },
                    :right => { :fixnum => cost }
                  }
                },
                :right => tree[:condition]
              }
            }
            effect[:do] = {
              :sequence => [ cost_effects, tree[:serif], effect[:do] ]
            } if tree[:serif]
          end
        end
        
      end
    end
  end
end
