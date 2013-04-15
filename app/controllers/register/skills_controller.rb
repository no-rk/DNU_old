class Register::SkillsController < Register::ApplicationController
  private
  def set_instance_variables
    @skills = Hash.new{ |hash,key| hash[key] = {} }
    current_user.result(:skill).where(:forget => false).includes(:skill).includes(:skill_name).find_each do |skill|
      skill_id = skill.skill.id
      @skills[skill_id][:nickname] = skill.nickname
    end
  end
  def build_record(record)
    kinds = [:battle]
    
    @skills.each do |skill_id, skill|
      kinds.each do |kind|
        first_or_build = { :kind => kind, :game_data_skill_id => skill_id }
        if record.skill_confs.exists?(first_or_build)
          skill_conf = record.skill_confs.where(first_or_build).first
        else
          skill_conf = record.skill_confs.build(first_or_build)
        end
        skill_conf.build_skill_name if skill_conf.skill_name.nil?
      end
    end
    record.skill_confs.sort_by!{ |r| r.game_data_skill_id.to_i }
  end
end
