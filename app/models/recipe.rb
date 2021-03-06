class Recipe < ActiveRecord::Base
    has_many :recipes_ingredients
    has_many :ingredients, through: :recipes_ingredients
    has_many :users_recipes
    has_many :users, through: :users_recipes

    def total_calories
        self.ingredients.map{|i| i.calories}.sum
    end
    def can_be_made_by?(user)
        can_make = true
        self.recipes_ingredients.each do |recipe_ingredient|
            # first find if the user has any of that item
            users_ingredient = user.users_ingredients.detect{|i| i.ingredient_id == recipe_ingredient.ingredient_id}
            if !users_ingredient || users_ingredient.quantity < recipe_ingredient.quantity # if the user doesn't have it or doesn't have enough of it
                can_make = false
            end
        end
        can_make
    end
    def make_recipe(user)
        self.recipes_ingredients.each do |recipe_ingredient|
            users_ingredient = user.users_ingredients.detect{|i| i.ingredient_id == recipe_ingredient.ingredient_id}
            if users_ingredient.quantity > recipe_ingredient.quantity # if the user has more than enough, remove that amount
                users_ingredient.quantity -= recipe_ingredient.quantity
                users_ingredient.save
            elsif users_ingredient.quantity == recipe_ingredient.quantity # if the user has exactly enough, remove the item from their pantry
                UsersIngredient.delete(users_ingredient.id)
            end
        end
    end
end