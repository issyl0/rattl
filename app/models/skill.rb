class Skill < ActiveRecord::Base
  has_many :users_skills
  has_many :users, through: :users_skills

  validates :name, presence: true
  after_validation :report_validation_errors_to_rollbar
end
