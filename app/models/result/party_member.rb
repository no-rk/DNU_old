class Result::PartyMember < ActiveRecord::Base
  belongs_to :party
  belongs_to :character, :polymorphic => true
  attr_accessible :correction
  
  has_one :day, :through => :party
  
  validates :character, :presence => true
  
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
