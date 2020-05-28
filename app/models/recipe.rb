class Recipe < ActiveRecord::Base
    has_many :ingredients, through: :recipes_ingredients
    has_many :users, through: :users_recipes
end