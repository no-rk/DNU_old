class GameData::Map < ActiveRecord::Base
  has_many :map_tips
  attr_accessible :base, :caption, :name
  
  has_many :places, :through => :map_tips, :class_name => "Result::Place"
  
  def where_places_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day).includes(:user)
  end
  
  def party_elements_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(:arrival => true).
           where(day_arel[:day].eq(day_i)).includes(:day).
           inject(Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = [] } }){ |h,r|
             h.tap{ h[r.map_tip_id][r.find_party_slogan_by_day_i(day_i)].push(r.user.id) }
           }
  end
  
  def through_map_tips_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(day_arel[:day].lteq(day_i)).includes(:day).includes(:map_tip).group(:map_tip_id).map{ |r| r.map_tip }
  end
end
