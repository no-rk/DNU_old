class Register::MainsController < Register::ApplicationController
  private
  def wrap_clone_record(record)
    if record.respond_to?(:day) and record.day.present?
      names = self.class.controller_name
      c_record = "Register::#{names.classify}".constantize.new
      # 合言葉は引き継ぐ
      c_record.build_party_slogan
      c_record.party_slogan.slogan = record.party_slogan.slogan
    else
      c_record = clone_record(record)
    end
    c_record
  end
  def set_instance_variables
    @direction_list ||= { :'休' => 0, :'上' => 1, :'右' => 2, :'下' => 3, :'左' => 4 }
    @selected_direction ||= @direction_list[:'休']
    @train_list ||= current_user.result_train
  end
end
