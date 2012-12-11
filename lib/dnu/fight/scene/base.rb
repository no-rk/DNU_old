module DNU
  module Fight
    module Scene
      class Base
        
        # 
        attr_accessor :index, :break, :parent
        
        # シーン名
        def self.human_name
          I18n.t(self.name.split("::")[3..4].join, :scope => "DNU.Fight.Scene")
        end
        
        # 
        def initialize(character, *arg)
          arg = arg.first || {}
          @character = character
          @active    = arg[:active].nil? ? character.live : arg[:active]
          @passive   = arg[:passive] if arg[:passive]
          @chains    = arg[:chains] if arg[:chains]
          @parent    = arg[:parent] if arg[:parent]
          @children  = self.initial_children
        end
        
        def has_next?
          @children.blank? ? self.add_if_blank : true
        end
        
        def add_if_blank
          child = self.create_child
          return false if child.nil?
          @children << child
          true
        end
        
        def next
          self.sort
          @children.shift
        end
        
        def each
          index = {}
          while self.has_next?
            child  = self.next
            index[child.class] = 1 if index[child.class].nil?
            child.index = index[child.class]
            yield child
            break if child.break
            index[child.class] += 1
          end
        end
        
        def before
          p I18n.t("Before", :scope => "DNU.Fight.Scene", :Scene=>self.class.human_name) + self.object_id.to_s
        end
        
        def play
          p "#{self.class.human_name}#{self.index}"
          self.before
          self.play_children if self.play_children?
          self.after
          self.chain
        end
        
        def after
          p I18n.t("After", :scope => "DNU.Fight.Scene", :Scene=>self.class.human_name) + self.object_id.to_s
        end
        
        def chain
        end
        
        # 以下をオーバーライドしてシーンの振る舞いを変える
        
        # 親シーン生成時に決定可能な子シーンを定義
        def initial_children
          []
        end
        
        # 親シーン生成時に決定不可能な子シーンを定義
        def create_child
          nil
        end
        
        def push_child(child)
          @children << child
        end
        
        # 
        def sort
        end
        
        #
        def play_children?
          true
        end
        
        #
        def play?
          true
        end
        
        # 
        def play_children
          self.each do |child|
            child.play if child.play?
          end
        end
        
      end
    end
  end
end
