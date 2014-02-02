class Skill < ActiveRecord::Base
  has_many :users_skills
  has_many :users, through: :users_skills

  validates :name, :proficiency, presence: true
end
