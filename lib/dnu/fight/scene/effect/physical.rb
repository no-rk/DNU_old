module DNU
  module Fight
    module Scene
      class Physical < BaseEffect
        def create_child
          return nil if rand(100) < 50
          rand(100) < 50 ? Success.new(self.character) : Failure.new(self.character)
        end

        class Success < BaseEffect
          def play_children
            p "Success"
          end
        end
        class Failure < BaseEffect
          def play_children
            p "Failure"
          end
        end
      end
    end
  end
end
