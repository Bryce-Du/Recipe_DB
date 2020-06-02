class AddCreatorToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :creator_id, :integer
  end
end
