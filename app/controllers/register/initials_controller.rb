class Register::InitialsController < Register::ApplicationController
  private
  def clone_record(record)
    record
  end
  def edit_action
    "new"
  end
  def set_instance_variables
    @jobs      ||= GameData::Art.find_all_by_type("職業").all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @guardians ||= GameData::Guardian.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
    @statuses  ||= GameData::Status.all.map{|t| {:id => t.id, :name => t.name} }
    @arts      ||= GameData::Art.find_all_by_type("武器").all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
  end
end
