# encoding: UTF-8
module DNU
  module Fight
    module State
      class Skill < BaseEffects
        
        attr_reader :cost, :require, :pre_phase, :targetable, :target, :definitions
        
        def when_initialize(tree)
          @cost        = DNU::Fight::State::Cost.new(tree[:cost])
          @require     = tree[:require]
          @pre_phase   = tree[:pre_phase]
          @targetable  = tree[:targetable]
          @target      = tree[:target] if @targetable
          @definitions = tree[:definitions]
          tree[:effects].each do |effect|
            effect[:priority]  = tree[:priority]
            effect[:condition] = {
              :condition_and => [
                {
                  :condition_ge => {
                    :left  => { :state_character => { :state_target=> "自分", :status_name=> "MP" } },
                    :right => { :fixnum => cost }
                  }
                },
                tree[:condition]
              ]
            }
            effect[:do] = {
              :sequence => [
                {
                  :root => {
                    :target => {
                      :set  => { :target_active   => nil },
                      :find => { :target_find_all => nil }
                    },
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
