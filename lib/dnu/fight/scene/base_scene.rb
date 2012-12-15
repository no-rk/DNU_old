# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseScene
        include Enumerable
        
        attr_reader :active, :passive, :label
        
        @@debug_log = []
        
        @@default_tree = {
          :sequence => [
            {
              :pre_phase => {
                :sequence => [
                  { :turn => { :act => { :effects => nil } } },
                  { :cemetery => nil }
                ]
              }
            },
            {
              :phase => {
                :sequence => [
                  {
                    :turn => {
                      :sequence => [
                        { :act => { :effects => nil } },
                        { :add_act => { :effects => nil } }
                      ]
                    }
                  },
                  { :cemetery => nil }
                ]
              }
            }
          ]
        }
        
        def p(msg)
          @@debug_log.push(msg)
        end
        
        # シーン名
        def self.human_name
          I18n.t(self.name.split("::").last, :scope => "DNU.Fight.Scene")
        end
        
        def when_initialize
        end
        
        def initialize(character, tree = @@default_tree, parent = nil)
          @character = character
          @tree      = tree
          @parent    = parent
          @children  = nil
          @active    = nil
          @passive   = nil
          @label     = nil
          @index     = 0
          when_initialize
        end
        
        def has_next_scene?
          @index == 0
        end
        
        def before_each_scene
        end
        
        def next_scene
          @active  = @parent.try(:active)
          @passive = @parent.try(:passive)
          @label   = @parent.try(:label).try(:dup) || {}
          before_each_scene
          self
        end
        
        def after_each_scene
        end
        
        def end_scene
          after_each_scene
          @index += 1
        end
        
        def after_all_scene
        end
        
        def rewind_scene
          after_all_scene
          @index = 0
        end
        
        def each
          while has_next_scene?
            yield next_scene
            end_scene
          end
          rewind_scene
        end
        
        def child_name(tree)
          tree.keys.first.try(:to_sym) || :undefined
        end
        
        def create_from_hash(tree)
          eval("#{child_name(tree).to_s.camelize}.new(@character,tree[child_name(tree)] , self)")
        end
        
        def before_create_children
        end
        
        def create_children
          before_create_children
          @children ||= create_from_hash(@tree)
        end
        
        def play_children
          @children.try(:play) || create_children.play
        end
        
        def before
          p "#{@active.name}の#{self.class.human_name}" unless @active.nil?
          p I18n.t("Before", :scope => "DNU.Fight.Scene", :Scene => "#{self.class.human_name}") + "(object_id:#{self.object_id})"
        end
        
        def after
          p I18n.t("After" , :scope => "DNU.Fight.Scene", :Scene => "#{self.class.human_name}") + "(object_id:#{self.object_id})"
        end
        
        def play
          self.each do |scene|
            before
            play_children
            after
          end
          @@debug_log
        end
      end
    end
  end
end
