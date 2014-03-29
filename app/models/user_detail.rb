class UserDetail < ActiveRecord::Base
  has_one :user

  validates :forename, :surname, :gender, :postcode, :dob, presence: true
  after_validation :report_validation_errors_to_rollbar
end
