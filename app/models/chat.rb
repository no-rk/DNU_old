class Chat < ActiveRecord::Base
  attr_accessible :data, :namespace, :room, :eno, :nickname, :text, :icons
  serialize :data
  
  def eno
    self.data ||= {}
    self.data[:eno]
  end
  
  def eno=(i)
    self.data ||= {}
    self.data[:eno] = i
  end
  
  def nickname
    self.data ||= {}
    self.data[:nickname]
  end
  
  def nickname=(i)
    self.data ||= {}
    self.data[:nickname] = i
  end
  
  def text
    self.data ||= {}
    self.data[:text]
  end
  
  def text=(t)
    self.data ||= {}
    self.data[:text] = t
  end
  
  def icons
    self.data ||= {}
    self.data[:icons].to_json
  end
  
  def icons=(t)
    self.data ||= {}
    self.data[:icons] = JSON.parse(t)
  end
  
  validates :text, :presence => true, :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
end
