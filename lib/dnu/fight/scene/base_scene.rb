# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseScene
        include Enumerable
        
        attr_reader :active, :passive, :label, :before, :after
        
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
        
        def logger(val)
          history[:debug] ||= []
          history[:debug] << val
        end
        
        def self_name
          self.class.name.split("::").last.to_sym
        end
        
        # シーン名
        def scene_name
          self_name
        end
        
        # シーン名（日本語）
        def human_name
          I18n.t(scene_name, :scope => "DNU.Fight.Scene")
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
          @before    = nil
          @after     = nil
          @history   = nil
          @index     = 0
          when_initialize
        end
        
        def has_next_scene?
          @index == 0
        end
        
        def before_all_scene
        end
        
        def before_each_scene
        end
        
        def next_scene
          @active  = @parent.try(:active)
          @passive = @parent.try(:passive)
          @label   = @parent.try(:label).try(:dup) || {}
          @before  = @parent.try(:before)
          @after   = @parent.try(:after)
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
          before_all_scene
          while has_next_scene?
            yield next_scene
            end_scene
          end
          rewind_scene
        end
        
        def child_name(tree)
          tree.keys.first.try(:to_sym)
        end
        
        def create_from_hash(tree)
          begin
            "DNU::Fight::Scene::#{child_name(tree).to_s.camelize}".constantize.new(@character,tree[child_name(tree)], self)
          rescue
            history[:children] << "#{scene_name}の子要素#{child_name(tree)}\{:#{
            tree[child_name(tree)].respond_to?(:keys) ? tree[child_name(tree)].keys.join(',:') : tree[child_name(tree)]
            }\}は未実装"
            Nothing.new(@character, tree[child_name(tree)], self)
          end
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
        
        def play_before
          @before ||= { :id => self.object_id, :effects => [] }
          [@active || @character].flatten.each do |char|
            while effects = char.effects.timing(scene_name).before.done_not.sample.try(:off)
              @before[:effects] << effects
              create_from_hash({
                :if => {
                  :condition=> effects.condition,
                  :then => {
                    :before => {
                      :active => char,
                      :do => effects.do,
                      :parent => human_name,
                      :type => effects.type,
                      :object_id => effects.object_id
                    }
                  }
                }
              }).play
            end
          end
          if @before[:id] == self.object_id
            @before[:effects].each{ |effects| effects.on }
            @before = nil
          end
        end
        
        def play_after
          @after ||= { :id => self.object_id, :effects => [] }
          [@active || @character].flatten.each do |char|
            while effects = char.effects.timing(scene_name).after.done_not.sample.try(:off)
              @after[:effects] << effects
              create_from_hash({
                :if => {
                  :condition=> effects.condition,
                  :then => {
                    :after => {
                      :active => char,
                      :do => effects.do,
                      :parent => human_name,
                      :type => effects.type,
                      :object_id => effects.object_id
                    }
                  }
                }
              }).play
            end
          end
          if @after[:id] == self.object_id
            @after[:effects].each{ |effects| effects.on }
            @after = nil
          end
        end
        
        def history
          @history.last[scene_name]
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
          @history << { scene_name => { :children => [] } }
          history[:active]  = @active.try(:name)
          history[:passive] = @passive.try(:name)
        end
        
        def play
          self.each do |scene|
            log_before_each_scene
            play_before
            play_children
            play_after
          end
          @history.extend Html
        end
        
      end
    end
  end
end
