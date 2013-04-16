module DNU
  module Process
    module Notice
      
      def notice
        # キャラ作成済みの各パーティー
        Result::Party.already_make(Day.last_day_i).find_each do |party|
          
          tree = {
            :pt_name    => "敵たち",
            :pt_caption => "テスト用",
            :members    => [
              { :kind => { :Monster => "モンスター" }, :name => "キュアプルプル" },
              { :kind => { :Monster => "モンスター" }, :name => "ピコピコテール" }
            ]
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
