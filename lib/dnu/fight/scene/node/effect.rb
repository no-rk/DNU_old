module DNU
  module Fight
    module Scene
      class Effect < Base
        
        # シーン名
        def self.human_name
          I18n.t(self.name.split("::")[3..4].join, :scope => "DNU.Fight.Scene")
        end
        
        # 技設定などに応じて構文木を取得
        def initial_children
          [Physical.new(@character,{
            :parent  => self,
            :active  => @active,
            :passive => @character.find_by_team_not(@active.team).random,
            :chains  => {:success => {:physical => {:success => :physical}}}
          })]
        end
        
        # 構文木を評価し効果を逐次生成
        def create_child
          nil
        end
        
      end
    end
  end
end
