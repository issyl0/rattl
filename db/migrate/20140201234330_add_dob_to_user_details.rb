class AddDobToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :dob, :date
  end
end
