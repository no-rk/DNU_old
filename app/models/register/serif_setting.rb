class Register::SerifSetting < ActiveRecord::Base
  belongs_to :battlable,     :polymorphic => true
  belongs_to :serif_setting, :class_name => "GameData::SerifSetting"
  attr_accessible :message, :serif_setting_id
  
  validates :serif_setting, :presence => true
  validates :message,       :length => { :maximum => Settings.maximum.message, :tokenizer => DNU::Text.counter(:message) }
  
  dnu_message_html  :message
  
  def user
    battlable.try(:user)
  end
  
  def day
    battlable.try(:day)
  end
  
  def character_active
    user
  end
  
  def character_passive
  end
  
  def collection
    @collection ||= GameData::SerifSetting.all.inject({}){|h,r| h.tap{h[r.name]=r.id} }
  end
end
