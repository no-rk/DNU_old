class Register::CatchPet < ActiveRecord::Base
  belongs_to :event
  belongs_to :character, :class_name => "GameData::Character"
  attr_accessible :correction, :index
  attr_writer :index
  
  has_one :user,            :through => :event
  has_one :day,             :through => :event
  has_one :event_content,   :through => :event
  has_one :game_data_event, :through => :event, :class_name => "GameData::Event", :source => :event
  
  validates :character, :presence => true
  
  def index
    @index || ((event_content.present? and character.present?) ? (event_content.content.find_index{|h| h[:kind]==character.kind and h[:name]==character.name and h[:correction].to_i==correction.to_i }) : nil)
  end
  
  def catch_pet!(way = self.game_data_event, day_i = self.day.day)
    user.add_pet!({self.character.kind => self.character.name}, self.correction, way, day_i)
  end
end
