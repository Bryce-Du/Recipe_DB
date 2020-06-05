class RecipeController < ApplicationController
    get "/recipes" do
        @users_recipes = UsersRecipe.all.select{|i| i.user_id == current_user.id}
        erb :"/recipes/list"
    end
    get "/recipes/new" do 
        erb :"/recipes/new"
    end
    get "/recipes/browse" do
        @recipes = Recipe.all
        erb :"/browse/recipes"
    end
    get "/recipes/:id" do
        @recipe = Recipe.find(params[:id])
        @recipes_ingredients = RecipesIngredient.where(recipe_id: @recipe.id)
        @error = []
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
        recipe.update(creator_id: current_user.id)
        # for each ingredient listed, find_or_create the ingredient, and then create the join model
        params["recipes_ingredient"].each do |recipe_ingredient|
            if recipe_ingredient["ingredient"]["name"] != "" # don't add ingredients if space left empty
                ingredient = Ingredient.find_by(name: recipe_ingredient["ingredient"]["name"])
                ingredient ||= Ingredient.create(recipe_ingredient["ingredient"])
                RecipesIngredient.create(ingredient_id: ingredient.id, quantity: recipe_ingredient["quantity"], recipe_id: recipe.id)
            end
        end
        # assign the recipe to the user
        UsersRecipe.create(recipe_id: recipe.id, user_id: current_user.id)
        redirect to "/recipes"
    end
    post "/recipes/:id/add" do
        UsersRecipe.create(recipe_id: params[:id], user_id: current_user.id)
        redirect to "/recipes"
    end
    post "/recipes/:id/make" do
        @recipe = Recipe.find(params[:id])
        @recipes_ingredients = @recipe.recipes_ingredients
        users_ingredients = UsersIngredient.where(user_id: current_user.id)
        @error = []

        @recipes_ingredients.each do |recipe_ingredient|
            # first find if the user has any of that item
            users_ingredient = users_ingredients.detect{|i| i.ingredient_id == recipe_ingredient.ingredient_id}
            if !!users_ingredient # if the user does have it
                if users_ingredient.quantity < recipe_ingredient.quantity # if they don't have enough, add error details
                    @error << "This recipe requires #{recipe_ingredient.quantity} #{recipe_ingredient.quantity > 2 ? recipe_ingredient.ingredient.name.pluralize : recipe_ingredient.ingredient.name}, you only have #{users_ingredient.quantity}."
                end
            else # the user doesn't have any, add error details
                @error << "This recipe requires #{recipe_ingredient.quantity} #{recipe_ingredient.quantity > 2 ? recipe_ingredient.ingredient.name.pluralize : recipe_ingredient.ingredient.name}, you have none."
            end
        end
        if @error.empty? # if the user has enough of all ingredients
            @recipes_ingredients.each do |recipe_ingredient|
                users_ingredient = users_ingredients.detect{|i| i.ingredient_id == recipe_ingredient.ingredient_id}
                if users_ingredient.quantity > recipe_ingredient.quantity # if the user has more than enough, remove that amount
                    users_ingredient.quantity -= recipe_ingredient.quantity
                    users_ingredient.save
                elsif users_ingredient.quantity == recipe_ingredient.quantity # if the user has exactly enough, remove the item from their pantry
                    UsersIngredient.delete(users_ingredient.id)
                end
            end
            @error << "You made this recipe! Ingredients have been removed from your pantry!"
        end
        erb :"/recipes/show"
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
        if !UsersRecipe.find_by(recipe_id: params[:id]) #if this recipe is not in anyone's cookbook.
            Recipe.delete(params[:id]) #delete the recipe itself
        end
        redirect to "/recipes"
    end
end