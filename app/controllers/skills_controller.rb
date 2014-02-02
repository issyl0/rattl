class SkillsController < ApplicationController
  def new
    @skill = Skill.new()
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      UsersSkill.create(user_id: current_user.id, skill_id: @skill.id)
      redirect_to root_path, :notice => "Skills saved successfully."
    end
  end

  private
  def skill_params
    params.require(:skill).permit(:name, :proficiency)
  end
end
