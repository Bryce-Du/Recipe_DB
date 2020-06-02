class RecipeController < ApplicationController
    get "/recipes" do
        @users_recipes = UsersRecipe.all.select{|i| i.user_id == current_user.id}
        erb :"/recipes/list"
    end
    get "/recipes/new" do 
        erb :"/recipes/new"
    end
    get "/recipes/:id" do
        @recipe = Recipe.find(params[:id])
        @recipes_ingredients = RecipesIngredient.where(recipe_id: @recipe.id)
        erb :"/recipes/show"
    end
    get "/recipes/:id/edit" do
        @recipe = Recipe.find(params[:id])
        @recipes_ingredients = RecipesIngredient.where(recipe_id: @recipe.id)
        erb :"/recipes/edit"
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
    patch "/recipes/:id/edit" do
        @recipe = Recipe.find(params[:id])
        @recipe.update(params["recipe"]) #updates name and instructions
        # to update recipes' ingredients, first remove current links, then re-create with new params
        RecipesIngredient.delete(RecipesIngredient.where(recipe_id: @recipe.id).map{|i| i.id}) 
        params["recipes_ingredient"].each do |recipe_ingredient|
            RecipesIngredient.create(ingredient_id: Ingredient.find_or_create_by(name: recipe_ingredient["ingredient"]["name"]).id, quantity: recipe_ingredient["quantity"], recipe_id: @recipe.id)
        end
        redirect to "/recipes"
    end
    delete "/recipes/:id" do
        UsersRecipe.delete(UsersRecipe.where(recipe_id: params[:id]).find_by(user_id: current_user.id).id)
        redirect to "/recipes"
    end

    #browse all

    get "/browse" do
        
    end
end