class RecipeController < ApplicationController
    get "/recipes" do
        @users_recipes = UsersRecipe.all.select{|i| i.user_id == current_user.id}
        erb :"/recipes/list"
    end
    get "/recipes/new" do 
        erb :"/recipes/new"
    end
    post "/recipes/new" do
        # unlike ingredients where an item of the same name should have the same info, 
        # two different recipes might exist that are called the same thing, but prepared in a unique way
        recipe = Recipe.create(params["recipe"])
        # for each ingredient listed, find_or_create the ingredient, and then create the join model
        params["recipes_ingredient"].each do |recipe_ingredient|
            RecipesIngredient.create(ingredient_id: Ingredient.find_or_create_by(name: recipe_ingredient["ingredient"]["name"]).id, quantity: recipe_ingredient["quantity"], recipe_id: recipe.id)
        end
        # assign the recipe to the user
        UsersRecipe.create(recipe_id: recipe.id, user_id: current_user.id)
        redirect to "/recipes"
    end
end