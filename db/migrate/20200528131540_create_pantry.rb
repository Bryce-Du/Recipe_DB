class CreatePantry < ActiveRecord::Migration
  def change
    create_table :users_ingredients do |t|
      t.belongs_to :user 
      t.belongs_to :ingredient
    end
  end
end
