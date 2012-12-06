module DNU
  module Fight
    module Scene
      class Physical < BaseEffect
        
        # 物理ダメージ
        def initial_children
          [rand(100) < 80 ? Success.new(@character,{:parent => self, :active => @active, :passive => @passive}) : Failure.new(@character,{:parent => self, :active => @active, :passive => @passive})]
        end
        
        class Success < BaseEffect
          def play_children
            dmg = rand(200)
            p "#{@active.object_id} attack to #{@passive.object_id}"
            p "#{dmg} dmg"
            @passive.HP.change_to(@passive.HP.value-dmg)
          end
        end
        
        class Failure < BaseEffect
          def play_children
            p "#{@active.object_id} attack to #{@passive.object_id}"
            p "#{@passive.object_id} avoid"
          end
        end
        
      end
    end
  end
end
