module DNU
  module Fight
    module Scene
      class Battle < BaseScene
        
        DEFAULT_TREE = {
          :sequence => [
            {
              :pre_phase => {
                :do => {
                  :sequence => [
                    { :prepare_turn => { :set_prepare_effects => nil } },
                    { :leadoff_turn => { :set_leadoff_effects => nil } },
                  ]
                },
                :after_each => {
                  :sequence => [
                    { :cemetery => nil },
                    { :formation => nil }
                  ]
                }
              }
            },
            {
              :phase => {
                :do => {
                  :turn => {
                    :sequence => [
                      { :act => { :set_effects => nil } },
                      { :add_act => { :set_effects => nil } }
                    ]
                  }
                },
                :after_each => {
                  :sequence => [
                    { :cemetery => nil },
                    { :formation => nil }
                  ]
                }
              }
            },
            { :result => nil }
          ]
        }
        
        def initialize(character, tree = DEFAULT_TREE, parent = nil)
          super
        end
        
        def before_each_scene
          @active = lambda{ @character.live }
        end
        
      end
    end
  end
end
