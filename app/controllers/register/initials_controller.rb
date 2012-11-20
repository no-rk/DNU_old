class Register::InitialsController < Register::ApplicationController
  private
  def clone_record(record)
    record
  end
  def edit_action
    "new"
  end
end
