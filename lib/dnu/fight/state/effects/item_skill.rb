module DNU
  module Fight
    module State
      class ItemSkill < BaseEffects
        
        attr_reader :hostility, :require, :pre_phasable, :definitions, :item
        
        def when_initialize(tree)
          set_hostility(tree[:effects])
          @pre_phasable = true
          @definitions  = tree[:definitions]
          @item         = tree[:item]
          @require      = nil
          tree[:effects].each do |effect|
            effect[:timing]    = tree[:timing]
            effect[:priority]  = tree[:priority]
            effect[:condition] = tree[:condition]
            effect[:do] = {
              :sequence => [
                tree[:serif],
                effect[:do],
                {:vanish=>{:item_skill=>{:this=>"戦物"}}}
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
