module DNU
  module Process
    module CatchPet
      
      def catch_pet
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          if user.register(:event).exists?
            user.register(:event).each do |event|
              event.catch_pets.each do |catch_pet|
                result_inventory = catch_pet.catch_pet!
                
                user.create_result!(:catch_pet, {
                  :catch_pet => catch_pet,
                  :number    => result_inventory.try(:number),
                  :pet       => result_inventory.try(:pet),
                  :success   => result_inventory.present?
                })
              end
            end
          end
        end
      end
      
    end
  end
end
