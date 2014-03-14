class SkillsController < ApplicationController
  def new
    @skill = Skill.new()
  end

  def create
    line = Array.new
    skill_params.each do |k,v|
      line = v.split("\r\n")
      line.each do |s|
        s = s.gsub(" ", "").split(",")
        @skill = Skill.new(name: s[0], proficiency: s[1])
        if @skill.save
          UsersSkill.create(user_id: current_user.id, skill_id: @skill.id)
        end
      end
      redirect_to root_path, :notice => "Skills saved successfully."
    end
  end

  private
  def skill_params
    params.require(:skill).permit(:name)
  end
end
