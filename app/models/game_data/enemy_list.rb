class GameData::EnemyList < ActiveRecord::Base
  attr_accessible :definition, :name
  
  has_many :enemy_list_elements
  
  has_many :enemy_territories
  
  has_many :result_party_members, :through => :enemy_list_elements
  
  validates :name,       :presence => true, :uniqueness => true
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def used?
    enemy_territories.exists? or result_party_members.exists?
  end
  
  def unused?
    !used?
  end
  
  private
  def set_game_data
    tree = DNU::Data.parse(self)
    if tree.present?
      self.name = tree[:name].to_s
      if self.unused?
        self.enemy_list_elements.destroy_all unless self.new_record?
        tree[:list].each do |enemy|
          self.enemy_list_elements.build do |enemy_list_element|
            enemy_list_element.character  = GameData::Character.find_by_kind_and_name(enemy[:kind], enemy[:name])
            enemy_list_element.correction = enemy[:correction].nil? ? 0 : "#{enemy[:correction][:minus].present? ? '-' : '+'}#{enemy[:correction][:value]}".to_i
            enemy_list_element.frequency  = (enemy[:frequency] || 1).to_f
          end
        end
      else
        errors[:base] << "使用中の#{self.class.model_name.human}のため編集できません。"
      end
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
