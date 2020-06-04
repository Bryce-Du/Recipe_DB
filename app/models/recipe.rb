class Recipe < ActiveRecord::Base
    has_many :recipes_ingredients
    has_many :ingredients, through: :recipes_ingredients
    has_many :users_recipes
    has_many :users, through: :users_recipes

    def total_calories
        self.ingredients.map{|i| i.calories}.sum
    end
end