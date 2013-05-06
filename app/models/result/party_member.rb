class Result::PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :character, :polymorphic => true
  attr_accessible :correction
  
  has_one :day, :through => :party
  
  validates :character, :presence => true
  
  def setting_tree(day_i = Day.last_day_i, battle_type = GameData::BattleType.normal.name)
    if @setting_tree.nil?
      @setting_tree = { :kind => character.kind, :correction => correction }
      if character_type.to_sym == :User
        @setting_tree.merge!(:eno => character_id)
        @setting_tree[:correction]  ||= day_i
        @setting_tree[:battle_type] ||= battle_type
      else
        @setting_tree.merge!(:name => character.name)
      end
    end
    @setting_tree
  end
  
  def pp_correction
    if correction.present?
      if correction>0
        " +#{correction}"
      elsif correction<0
        " #{correction}"
      end
    end
  end
end
