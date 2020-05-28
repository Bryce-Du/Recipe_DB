class CreateUsersRecipes < ActiveRecord::Migration
  def change
    create_table :users_recipes do |t|
      t.belongs_to :user
      t.belongs_to :recipe
    end
  end
end
