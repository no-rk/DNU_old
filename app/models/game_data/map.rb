class GameData::Map < ActiveRecord::Base
  has_many :map_tips, :include => :landform
  attr_accessible :base, :caption, :name, :map_tips_attributes, :map_size
  attr_writer :map_size, :definition
  
  has_many :enemy_territories
  accepts_nested_attributes_for :map_tips
  
  has_many :result_maps, :class_name => "Result::Map"
  
  has_many :places, :through => :map_tips, :class_name => "Result::Place"
  
  validates :name, :presence => true, :uniqueness => true
  validates :base, :inclusion => { :in => ["field", "dangeon"] }
  
  before_validation :set_game_data
  after_save :sync_game_data
  
  scope :already_make, lambda{ joins(:result_maps).uniq }
  scope :has_anyone,   lambda{ joins(:places).uniq }
  
  def map_size
    @map_size || map_tips.maximum(:x)
  end
  
  def where_shouts_by_day_i(day_i = Day.last_day_i)
    where_places_by_day_i(day_i).map{ |place|
      if place.user.register(:main, day_i).present?
        place.user.register(:main, day_i).shouts.map{ |shout|
          {
            :x      => place.map_tip.x,
            :y      => place.map_tip.y,
            :volume => shout.volume,
            :shout  => shout
          }
        }
      end
    }.flatten.compact
  end
  
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
  
  def arrival_map_tips_by_day_i(day_i = Day.last_day_i)
    day_arel = Day.arel_table
    places.where(:arrival => true).where(day_arel[:day].eq(day_i)).includes(:day).includes(:map_tip).group(:map_tip_id).map{ |r| r.map_tip }
  end
  
  def definition
    if @definition.nil?
      {
        :name       => name,
        :caption    => caption,
        :base       => base,
        :attributes => map_tips.select([:x, :y, :landform_id, :collision, :opacity]).includes(:landform).map{|r|{:x=>r.x, :y=>r.y, :landform=>r.landform.image, :collision=>r.collision, :opacity=>r.opacity }}
      }
    else
      @definition
    end
  end
  
  private
  def set_game_data
    if @definition.present?
      if definition[:attributes].present?
        self.name    = definition[:name].to_s
        self.caption = definition[:caption].to_s
        self.base    = definition[:base].to_s
        definition[:attributes].each do |map_tip|
          self.map_tips.build(map_tip.except(:landform)) do |game_data_map_tip|
            game_data_map_tip.landform = GameData::Landform.find_by_image(map_tip[:landform])
          end
        end
      else
        errors.add(:definition, :invalid)
      end
    end
  end
  def sync_game_data
    DNU::Data.sync(self)
  end
end
