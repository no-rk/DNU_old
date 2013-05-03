class GameData::Character < ActiveRecord::Base
  attr_accessible :definition, :kind, :name, :tree
  serialize :tree
  
  validates :kind,       :presence => true
  validates :name,       :presence => true, :uniqueness => {:scope => :kind }
  validates :definition, :presence => true
  
  before_validation :set_game_data
  after_save        :sync_game_data
  
  def self.status_from_rank(rank)
    rank.to_i*20+50
  end
  
  def self.equip_from_rank(rank)
    rank.to_i*10+50
  end
  
  def self.set_strength_from_rank!(character_tree)
    if character_tree[:rank].present?
      rank = character_tree[:rank].to_i + character_tree[:correction].to_i
      rank = 1 if rank < 1
      
      # 能力
      GameData::Status.pluck(:name).each do |status_name|
        unset = true
        
        character_tree[:settings].find_all{ |s| s[:status].try('[]', :name).to_s == status_name.to_s }.each do |setting|
          setting[:status][:status_strength] ||= ((setting[:status][:status_rate] || 1).to_f*self.status_from_rank(rank)).to_i
          unset = false
        end
        
        if unset
          character_tree[:settings] << {
            :status => {
              :name            => status_name,
              :status_strength => status_from_rank(rank)
            }
          }
        end
      end
      
      # 装備
      character_tree[:settings].find_all{ |s| s.keys.first == :equip }.each do |setting|
        setting[:equip][:equip_strength] ||= ((setting[:equip][:equip_rate] || 1).to_f*self.equip_from_rank(rank)).to_i
      end
    end
    character_tree
  end
  
  def pet_data(correction = 0)
    character_tree = self.class.set_strength_from_rank!(tree.merge(:correction => correction))
    status_data = character_tree[:settings].
                  find_all{|h| h[:status].present? }.
                  map{|h| h[:status]}.
                  group_by{|h|h[:name]}.
                  map{|(k,v)| [:pet_status, {:name => v.first[:name], :bonus => v.sum{|h| h[:status_strength]} }] }
    sup_data = character_tree[:settings].
               find_all{|h| h[:sup].present? }.
               map.with_index(1){|h,i| [:pet_sup, h.values.first.merge(:number => i)] }
    skill_data = character_tree[:settings].
                 find_all{|h| h[:skill].present? }.
                 uniq{|h| h[:skill][:name] }.
                 map.with_index(1){|h,i| [:pet_skill, { :name => h[:skill][:name],:number => i }] }
    { 
      :kind => character_tree[:kind],
      :name => character_tree[:name],
      :settings => status_data + sup_data + skill_data
    }
  end
  
  private
  def set_game_data
    definition_tree = DNU::Data.parse_from_model(self, true)
    if definition_tree.present?
      self.kind = definition_tree[:kind].to_s
      self.name = definition_tree[:name].to_s
      self.tree = definition_tree
    else
      errors.add(:definition, :invalid)
    end
  end
  
  def sync_game_data
    DNU::Data.sync(self)
  end
end
