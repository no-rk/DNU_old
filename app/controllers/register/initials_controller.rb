class Register::InitialsController < Register::ApplicationController
  private
  def clone_record(record)
    record
  end
  def edit_action
    "new"
  end
  def set_instance_variables
    @jobs      ||= GameData::Job.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @guardians ||= GameData::Guardian.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @statuses  ||= GameData::Status.all.map{|t| {:id => t.id, :name => t.name} }
    @arts      ||= GameData::Art.where(GameData::ArtType.arel_table[:name].eq("武器")).includes(:art_type).all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
  end
end
