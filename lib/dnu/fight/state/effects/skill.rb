# encoding: UTF-8
module DNU
  module Fight
    module State
      class Skill < BaseEffects
        
        attr_reader :cost, :require, :pre_phase, :targetable, :target
        
        def when_initialize(tree)
          @cost       = DNU::Fight::State::Cost.new(tree[:cost])
          @require    = tree[:require]
          @pre_phase  = tree[:pre_phase]
          @targetable = tree[:targetable]
          @target     = tree[:target] if @targetable
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
              :sequence => [
                {
                  :root => {
                    :passive => { :scope => "自" },
                    :do => {
                      :effect => {
                        :cost => { :change_value => { :fixnum => cost } }
                      }
                    }
                  }
                },
                tree[:serif],
                effect[:do]
              ].compact
            }
          end
        end
        
      end
    end
  end
end
