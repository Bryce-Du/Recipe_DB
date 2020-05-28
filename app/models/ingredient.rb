class Ingredient < ActiveRecord::Base
    has_many :recipes_ingredients
    has_many :recipes, through: :recipes_ingredients
    has_many :users_ingredients
    has_many :users, through: :users_ingredients
end