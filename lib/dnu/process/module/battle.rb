module DNU
  module Process
    module Battle
      
      def battle
        # キャラ作成済みの各パーティー
        Result::Party.already_make.find_each do |party|
          if party.notices.exists?
            notice = party.notices.first
            
            notice.battle.try(:destroy)
            battle_tree = DNU::Fight::Scene::Battle.new(notice.characters).play
            
            result_battle = Result::Battle.new
            result_battle.notice = notice
            result_battle.html   = battle_tree.to_html
            result_battle.tree   = battle_tree
            result_battle.save!
          end
        end
      end
      
    end
  end
end
