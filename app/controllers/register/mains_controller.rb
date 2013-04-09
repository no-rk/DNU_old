class Register::MainsController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      c_record = Register::Main.new
      c_record.build_main
      # 合言葉は引き継ぐ
      if record.party_slogan.present?
        c_record.build_party_slogan
        c_record.party_slogan.slogan = record.party_slogan.slogan
      end
    else
      c_record = clone_record(record)
    end
    c_record
  end
  def set_instance_variables
    @direction_list ||= { :'休' => 0, :'上' => 1, :'右' => 2, :'下' => 3, :'左' => 4 }
    @selected_direction ||= @direction_list[:'休']
    @train_list ||= current_user.result_train
    ids = GameData::ArtType.find_by_name("武器").arts.pluck(:id) - current_user.result(:art).where(:forget => false).map{ |r| r.art_id }
    @blossom_list ||= GameData::Train.where(:trainable_id => ids, :trainable_type => "GameData::Art").includes(:trainable).inject({}){ |h,r| h.tap{ h[r.trainable.name] = r.id } }
  end
end
