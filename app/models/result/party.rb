class Result::Party < ActiveRecord::Base
  belongs_to :day
  has_many :party_members, :dependent => :destroy
  has_many :notices, :dependent => :destroy
  attr_accessible :caption, :kind, :name
  
  scope :where_user_ids_and_day_i, lambda{ |user_ids, day_i|
    pm_arel = Result::PartyMember.arel_table
    day_arel = Day.arel_table
    
    where(pm_arel[:character_type].eq(:User)).
    where(pm_arel[:character_id].in(user_ids)).includes(:party_members).
    where(day_arel[:day].eq(day_i)).includes(:day).
    uniq
  }
  
  def nickname
    name || "第#{id}PT"
  end
end
