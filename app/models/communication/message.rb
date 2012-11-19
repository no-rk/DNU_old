require "active_form"
class Communication::Message < ActiveForm
  validates :recipients, :presence => true
  validates :subject, :length => { :maximum => 20 }
  validates :body, :presence => true, :length => { :maximum => 140 }

  attr_accessor :recipients, :subject, :body
end
