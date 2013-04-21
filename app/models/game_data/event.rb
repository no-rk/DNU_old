class GameData::Event < ActiveRecord::Base
  attr_accessible :caption, :kind, :name, :definition
  
  has_many :event_steps
  has_many :event_contents, :through => :event_steps
  
  validates :kind,       :inclusion => { :in => ["通常", "共通", "内部"] }
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      # Event
      self.kind    = (tree[:kind] || "通常").to_s
      self.name    = tree[:name].to_s
      self.caption = tree[:caption].to_s
      # EventStep
      #self.event_steps.destroy_all if self.event_steps.present?
      tree[:steps].each do |step|
        self.event_steps.build do |event_step|
          event_step.timing    = step[:timing].keys.first.to_s
          event_step.condition = step[:condition].to_hash
          step[:contents].each do |content|
            event_step.event_contents.build do |event_content|
              event_content.kind    = content.keys.first
              event_content.content = content.values.first
            end
          end
        end
      end
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
