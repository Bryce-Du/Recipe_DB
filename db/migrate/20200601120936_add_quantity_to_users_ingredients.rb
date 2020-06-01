class AddQuantityToUsersIngredients < ActiveRecord::Migration
  def change
    add_column :users_ingredients, :quantity, :integer
  end
end
