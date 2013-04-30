class GameData::EventContent < ActiveRecord::Base
  belongs_to :event_step
  attr_accessible :content, :kind
  serialize :content
  
  has_one :event, :through => :event_step
  
  def nickname
    event_step.nickname
  end
  def collection
    case kind.to_sym
    when :purchase
      content.each.with_index.inject({}){|h,(v,i)| h.tap{ h["[#{v[:kind]}]#{v[:name]} #{v[:price]}#{v[:point]}"] = i } }
    end
  end
end
