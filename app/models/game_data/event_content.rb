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
    when :catch_pet
      content.each.with_index.inject({}){|h,(v,i)| h.tap{ h["[#{v[:kind]}]#{v[:name]}#{p_correction(v[:correction])}"] = i } }
    end
  end
  
  def p_correction(correction)
    unless correction.to_i==0
      %Q| #{sprintf("%+d", correction.to_i)}|
    end
  end
end
