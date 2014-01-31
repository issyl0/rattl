class UserDetail < ActiveRecord::Base
	has_one :user

	validates :forename, :surname, :gender, :postcode, presence: true
end
