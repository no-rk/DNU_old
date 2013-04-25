# encoding: UTF-8
module DNU
  module Fight
    module State
      class Skill < BaseEffects
        
        attr_reader :cost, :require, :hostility, :pre_phasable, :targetable, :target, :definitions
        
        def when_initialize(tree)
          @cost         = DNU::Fight::State::BaseValue.new(nil, tree[:cost])
          @cost.start(0, 10**10)
          @require      = tree[:require]
          set_hostility(tree[:effects])
          @pre_phasable = tree[:pre_phasable]
          @targetable   = tree[:targetable]
          @target       = tree[:target] if @targetable
          @definitions  = tree[:definitions]
          tree[:effects].each do |effect|
            effect[:timing]    = tree[:timing]
            effect[:priority]  = tree[:priority]
            effect[:condition] = {
              :condition_and => [
                {
                  :condition_ge => {
                    :left  => { :state_character => { :state_target=> "自分", :battle_value => "MP" } },
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
        
        def set_hostility(obj)
          catch :hostility do
            apply(obj)
          end
        end
        
        def apply(obj)
          case obj
          when Hash
            recurse_hash(obj)
          when Array
            recurse_array(obj)
          end
        end
        
        def recurse_hash(hsh)
          hsh.each do |k,v|
            case k.to_sym
            when :target_other_team
              @hostility = true
              throw :hostility
            when :target_complement
              apply(v[:left])
            when :if
              unless v[:condition].keys.first.to_sym == :in_phase
                apply(v)
              end
            else
              apply(v)
            end
          end
        end
        
        def recurse_array(ary)
          ary.each do |v|
            apply(v)
          end
        end
        
      end
    end
  end
end
