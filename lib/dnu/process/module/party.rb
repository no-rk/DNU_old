module DNU
  module Process
    module Party
      
      def party
        GameData::Map.find_each do |map|
          map.party_elements_by_day_i.each do |map_tip_id, h|
            h.each do |slogan, user_ids|
              if slogan.nil?
                # 合言葉未入力なのでソロPT
                user_ids.each do |user_id|
                  party = Result::Party.new
                  party.day = Day.last
                  party.kind = "battle"
                  party.party_members.build
                  party.party_members.first.character = User.find(user_id)
                  party.save!
                end
              else
                # PT結成を試みる
                party_max = 3
                party_number = (user_ids.count.to_f/party_max).ceil
                
                pts = []
                party_number.times{ pts.push([]) }
                
                user_ids.shuffle.each_with_index do |user_id, i|
                  pts[i%party_number].push(user_id)
                end
                pts.each do |pt|
                  pt.sort!
                  party = Result::Party.new
                  party.day = Day.last
                  party.kind = "battle"
                  pt.each do |user_id|
                    party.party_members.build do |party_member|
                      party_member.character = User.find(user_id)
                    end
                  end
                  party.save!
                end
              end
            end
          end
        end
      end
      
    end
  end
end
