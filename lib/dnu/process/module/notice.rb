module DNU
  module Process
    module Notice
      
      def notice
        # キャラ作成済みの各パーティー
        Result::Party.already_make.find_each do |party|
          if party.enemy_territory.present?
            tree = {
              :pt_name    => "敵たち",
              :pt_caption => "テスト用",
              :members    => party.enemy_territory.enemy_list.enemy_list_elements.sample(party.party_members.count)
            }
            
            party.notices.build do |notice|
              notice.kind = "battle"
              notice.enemy = Result::Party.new_from_tree(tree)
            end
            party.save!
          end
        end
      end
      
    end
  end
end
