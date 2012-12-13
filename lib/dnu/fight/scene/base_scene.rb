module DNU
  module Fight
    module Scene
      class BaseScene
        include Enumerable
        
        @@default_tree = {
          :sequence => [
            {
              :sequence => [
                {
                  :pre_phase => {
                    :turn => { :act => { :effects => nil } }
                  }
                },
                { :cemetery => nil }
              ]
            },
            {
              :sequence => [
                {
                  :phase=>{
                    :turn=>{
                      :sequence=>[
                        { :act => { :effects => nil } },
                        { :add_act=> { :effects => nil } }
                      ]
                    }
                  }
                },
                { :cemetery => nil }
              ]
            }
          ]
        }
        
        # ƒV[ƒ“–¼
        def self.human_name
          I18n.t(self.name.split("::").last, :scope => "DNU.Fight.Scene")
        end
        
        def initialize(character, tree = @@default_tree, parent = nil)
          @character = character
          @tree      = tree
          @parent    = parent
          @children  = nil
          @index     = 0
        end
        
        def has_next_scene?
          @index == 0
        end
        
        def next_scene
          self
        end
        
        def seek_scene
          @index += 1
        end
        
        def rewind_scene
          @index = 0
        end
        
        def each
          while has_next_scene?
            yield next_scene
            seek_scene
          end
          rewind_scene
        end
        
        def child_name(tree)
          tree.keys.first.try(:to_sym) || :undefined
        end
        
        def create_from_hash(tree)
          #p "#{child_name(tree).to_s.camelize}.new(@character,tree[child_name(tree)] , self)"
          eval("#{child_name(tree).to_s.camelize}.new(@character,tree[child_name(tree)] , self)")
        end
        
        def create_children
          @children ||= create_from_hash(@tree)
        end
        
        def play_children
          @children.try(:play) || create_children.play
        end
        
        def before
          p I18n.t("Before", :scope => "DNU.Fight.Scene", :Scene => self.class.human_name + @index.to_s) + self.object_id.to_s
        end
        
        def after
          p I18n.t("After" , :scope => "DNU.Fight.Scene", :Scene => self.class.human_name + @index.to_s) + self.object_id.to_s
        end
        
        def play
          self.each do |scene|
            before
            play_children
            after
          end
        end
      end
    end
  end
end
