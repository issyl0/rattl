class AddUserIdToUserDetails < ActiveRecord::Migration
  def change
  	add_reference :user_details, :user
  end
end
