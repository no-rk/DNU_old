# encoding: UTF-8
module DNU
  module Fight
    module Scene
      class BaseScene
        include Enumerable
        
        attr_reader :active, :passive, :label, :pool, :stack, :data
        
        @@default_tree = {
          :sequence => [
            {
              :pre_phase => {
                :sequence => [
                  { :prepare_turn => { :set_prepare_effects => nil } },
                  { :leadoff_turn => { :set_leadoff_effects => nil } },
                  { :cemetery => nil },
                  { :formation => nil }
                ]
              }
            },
            {
              :phase => {
                :sequence => [
                  {
                    :turn => {
                      :sequence => [
                        { :act => { :set_effects => nil } },
                        { :add_act => { :set_effects => nil } }
                      ]
                    }
                  },
                  { :cemetery => nil },
                  { :formation => nil }
                ]
              }
            },
            { :result => nil }
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
          @pool      = nil
          @stack     = nil
          @data      = nil
          @history   = nil
          @index     = 0
          when_initialize
        end
        
        def has_next_scene?
          @index == 0
        end
        
        def wrap_has_next_scene?
          @active  = @parent.try(:active)
          @passive = @parent.try(:passive)
          @label   = @parent.try(:label) || {}
          @pool    = @parent.try(:pool)
          @stack   = @parent.try(:stack) || []
          @data    = @parent.try(:data)
          has_next_scene?
        end
        
        def before_all_scene
        end
        
        def before_each_scene
        end
        
        def next_scene
          before_each_scene
          log_before_each_scene
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
          @index = 0
          before_all_scene
          while wrap_has_next_scene?
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
            "DNU::Fight::Scene::#{child_name(tree).to_s.camelize}".constantize.new(@character, tree[child_name(tree)], self)
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
        
        def play_(b_or_a, c=nil, scene=scene_name)
          @pool ||= { :id => object_id, :effects => [] }
          active_array = [@active.try(:call) ].flatten.compact.map{|char| { :ant =>  nil , :active_now => char } } +
                         [@passive.try(:call)].flatten.compact.map{|char| { :ant => :ant , :active_now => char } }
          active_array.sort_by{rand}.each do |char|
            ant         = char[:ant]
            active_now  = char[:active_now]
            passive_now = ant.nil? ? [@passive.try(:call)].flatten.compact.sample : [@active.try(:call)].flatten.compact.sample
            while effects = active_now.effects.timing(:"#{scene}#{ant.to_s.camelize}").send(b_or_a).done_not.sample
              effects.off
              @pool[:effects] << effects
              create_from_hash({
                :if => {
                  :condition=> effects.condition,
                  :then => {
                    (c || b_or_a) => {
                      :parent => :"#{scene}#{ant.to_s.camelize}",
                      :effects => effects,
                      :b_or_a => b_or_a.to_s.camelize
                    }
                  },
                  :lv => effects.LV,
                  :active  => active_now,
                  :passive => passive_now
                }
              }).play
            end
          end
          if @pool[:id] == object_id
            clear_pool
          end
          interrupt_before_play
        end
        
        def clear_pool
          @pool[:effects].each{ |effects| effects.on } unless @pool.nil?
          @pool = nil
        end
        
        def history
          @history.last[scene_name]
        end
        
        def log_before_each_scene
          @history = @parent.try(:history) || {}
          @history = @history[:children] ||= []
          @history << { scene_name => { :children => [] } }
          history[:active]  = [@active.try(:call)].flatten.compact.map{|c| c.try(:name)}
          history[:passive] =  @passive.try(:call).try(:name)
        end
        
        def interrupt_before_play
          if @stack.last.try(:interrupt).try(:call)
            @stack.last.interrupt = nil
            throw :"#{@stack.last.type}#{@stack.last.object_id}"
          end
        end
        
        def play
          self.each do |scene|
            play_(:before)
            play_children
            play_(:after)
          end
          @history.extend Html
        end
        
      end
    end
  end
end
