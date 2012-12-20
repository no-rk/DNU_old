# encoding: UTF-8
module DNU
  module Fight
    module Scene
      module Change
        
        def 対象
          @passive
        end
        
        # 変化
        def change_value(tree)
          logger(tree[:status_name] => 対象.send(tree[:status_name]).val) unless tree[:status_name].nil?
          logger(:val               => 対象.send(tree[:status_name]).status.val) unless tree[:status_name].nil?
          logger(:equip_val         => 対象.send(tree[:status_name]).equip.val) unless tree[:status_name].nil?
          lambda do
            change = tree[:status_name].nil? ? 0 : 対象.send(tree[:status_name]).send(tree[:equip].nil? ? :status : :equip)
            change = change*tree[:coeff_A].to_f + tree[:coeff_B].to_f
            change.to_i
          end
        end
        
      end
    end
  end
end
