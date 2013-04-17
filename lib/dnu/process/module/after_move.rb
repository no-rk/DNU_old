module DNU
  module Process
    module AfterMove
      
      def after_move
        # キャラ作成済みの各ユーザー
        User.already_make.find_each do |user|
          user.result_event_states_by_timing(:after_move).find_all{ |r| r.satisfy? }.each do |event_state|
            event_contents = event_state.start
            event_contents.each do |event_content|
              user.create_result!(:after_move, { :event_content => event_content })
            end
          end
        end
      end
      
    end
  end
end
