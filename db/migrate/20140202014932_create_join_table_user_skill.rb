class CreateJoinTableUserSkill < ActiveRecord::Migration
  def change
    create_join_table :users, :skills, table_name: :users_skills
  end
end
