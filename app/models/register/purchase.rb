class Register::Purchase < ActiveRecord::Base
  belongs_to :event
  belongs_to :item,  :class_name => "GameData::Item"
  belongs_to :point, :class_name => "GameData::Point"
  attr_accessible :item_id, :index
  attr_writer :index
  
  has_one :user,            :through => :event
  has_one :day,             :through => :event
  has_one :event_content,   :through => :event
  has_one :game_data_event, :through => :event, :class_name => "GameData::Event", :source => :event
  
  validates :item,  :presence => true
  validates :point, :presence => true
  validates :price, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  
  def index
    @index || ((event_content.present? and item.present?) ? (event_content.content.find_index{|h| h[:kind]==item.kind and h[:name]==item.name }) : nil)
  end
  
  def purchase!(way = self.game_data_event, day_i = self.day.day)
    success = false
    if user.blank_item_number(day_i).present?
      point_arel = GameData::Point.arel_table
      result_point = user.result(:point).where(point_arel[:name].eq(self.point.name)).includes(:point).first
      if result_point.present?
        result_point.value -= self.price
        if result_point.save
          success = user.add_item!({self.item.kind => self.item.name}, way, day_i)
        end
      end
    end
    success
  end
end
