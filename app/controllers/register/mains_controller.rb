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
    
    @train_list ||= current_user.result(@read_only ? :trainable_all : :trainable)
    
    at_arel = GameData::ArtType.arel_table
    forget_ids = current_user.result(:art).where(at_arel[:name].eq("武器")).includes(:art_type)
    forget_ids = forget_ids.where(:forget => false) unless @read_only
    forget_ids = forget_ids.map{ |r| r.art_id }
    @forget_list ||= GameData::Train.where(:trainable_id => forget_ids, :trainable_type => "GameData::Art").includes(:trainable).inject({}){ |h,r| h.tap{ h[r.trainable.name] = r.id } }
    
    blossom_ids = GameData::ArtType.find_by_name("武器").arts.pluck(:id)
    blossom_ids -= current_user.result(:art).where(:forget => false).map{ |r| r.art_id } unless @read_only
    @blossom_list ||= GameData::Train.where(:trainable_id => blossom_ids, :trainable_type => "GameData::Art").includes(:trainable).inject({}){ |h,r| h.tap{ h[r.trainable.name] = r.id } }
  end
end
