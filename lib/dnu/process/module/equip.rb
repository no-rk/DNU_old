module DNU
  module Process
    module Equip
      
      def equip
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:battle).present?
            user.register(:battle).each do |register_battle|
              register_battle.equips.each do |equip|
                result_inventory = user.result(:inventory).where(:number => equip.number).first
                
                user.create_result!(:equip, {
                  :battle_type => equip.battlable.battle_type,
                  :equip       => equip,
                  :inventory   => result_inventory,
                  :success     => result_inventory.try(:item).try(:equip_type).to_s == equip.kind.to_s
                })
              end
            end
          end
        end
      end
      
    end
  end
end
