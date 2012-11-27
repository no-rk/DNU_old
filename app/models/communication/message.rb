class Communication::Message < ActiveForm
  validates :recipients, :presence => true
  validates :subject, :length => { :maximum => 20 }
  validates :body, :presence => true, :length => { :maximum => 140 }

  attr_accessor :recipients, :subject, :body

  def column_for_attribute(attribute_name)
    Notification.new.column_for_attribute(attribute_name)
  end
end
