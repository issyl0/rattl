class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.string :forename, null: false
      t.string :surname, null: false
      t.string :gender
      t.string :postcode

      t.timestamps
    end
  end
end
