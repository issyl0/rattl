class UsersSkill < ActiveRecord::Base
  self.table_name = "users_skills"

  belongs_to :user
  belongs_to :skill
end
