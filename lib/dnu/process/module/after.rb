module DNU
  module Process
    module After
      
      def after
        now_day = Day.last
        
        # �����X�e�[�^�X�𖢊m��ɂ���
        now_day.state = 1
        now_day.save!
      end
      
    end
  end
end
