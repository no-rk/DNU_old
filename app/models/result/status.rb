class Result::Status < ActiveRecord::Base
  belongs_to :character, :polymorphic => true
  belongs_to :day
  belongs_to :status, :class_name => "GameData::Status"
  attr_accessible :bonus, :caption, :count, :name

  has_one :train, :through => :status, :class_name => "GameData::Train"

  def grow_using_point_name!(point_name)
    success = false
    point_arel = GameData::Point.arel_table
    result_point = self.character.result(:point, self.day.day).where(point_arel[:name].eq(point_name)).includes(:point).first
    if result_point.present?
      result_point.value -= self.require_point
      if result_point.save
        self.count += 1
        self.save!
        success = true
      end
    end
    success
  end
  
  def value(n = count)
    ((1.0/4)*(n+10)*(n+20)).ceil
  end
  def require_point(n = count)
    (value(n)/10).to_i
  end
  def nickname
    name || status.name
  end
end
