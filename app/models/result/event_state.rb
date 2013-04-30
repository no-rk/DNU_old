class Result::EventState < ActiveRecord::Base
  include DNU::Event::Condition
  include DNU::Event::Content
  
  belongs_to :event
  belongs_to :event_step, :class_name => "GameData::EventStep"
  attr_accessible :state
  
  has_many :event_variables, :through => :event
  
  has_one :passed_day, :through => :event
  has_one :user,       :through => :event
  has_one :day,        :through => :event
  
  has_one :game_data_event, :through => :event, :class_name => "GameData::Event", :source => :event
  
  has_many :event_contents, :through => :event_step, :class_name => "GameData::EventContent"
  
  has_many :result_send_points,   :through => :passed_day, :class_name => "Result::SendPoint"
  has_many :result_send_items,    :through => :passed_day, :class_name => "Result::SendItem"
  has_many :result_forges,        :through => :passed_day, :class_name => "Result::Forge"
  has_many :result_supplements,   :through => :passed_day, :class_name => "Result::Supplement"
  has_many :result_equips ,       :through => :passed_day, :class_name => "Result::Equip"
  has_many :result_trains,        :through => :passed_day, :class_name => "Result::Train"
  has_many :result_learns,        :through => :passed_day, :class_name => "Result::Learn"
  has_many :result_forgets,       :through => :passed_day, :class_name => "Result::Forget"
  has_many :result_blossoms,      :through => :passed_day, :class_name => "Result::Blossom"
  has_many :result_moves,         :through => :passed_day, :class_name => "Result::Move"
  
  has_many :result_battle_values, :through => :passed_day, :class_name => "Result::BattleValue"
  has_many :result_points,        :through => :passed_day, :class_name => "Result::Point"
  has_many :result_jobs,          :through => :passed_day, :class_name => "Result::Job"
  has_many :result_statuses,      :through => :passed_day, :class_name => "Result::Status"
  has_many :result_arts,          :through => :passed_day, :class_name => "Result::Art"
  has_many :result_products,      :through => :passed_day, :class_name => "Result::Product"
  has_many :result_abilities,     :through => :passed_day, :class_name => "Result::Ability"
  has_many :result_skills,        :through => :passed_day, :class_name => "Result::Skill"
  has_many :result_inventories,   :through => :passed_day, :class_name => "Result::Inventory"
  has_many :result_places,        :through => :passed_day, :class_name => "Result::Place"
  
  validates :event_step, :presence => true
  validates :state,      :inclusion => { :in => ["途中", "終了"] }
  
  def start
    print_texts = []
    if satisfy?
      event_contents.each do |event_content|
        case event_content.kind.to_sym
        when :print_text
          print_texts.push(event_content)
        else
          start_content(event_content)
        end
      end
    end
    print_texts
  end
  
  def satisfy?
    check_condition(self.event_step.condition).call
  end
end
