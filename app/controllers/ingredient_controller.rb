class IngredientController < ApplicationController
    get "/ingredients" do
        @users_ingredients = UsersIngredient.all.map{|i| i.user_id == current_user.id}
        erb :"/ingredients/list"
    end
    get "/ingredients/new" do 
        erb :"/ingredients/new"
    end
    post "/ingredients/new" do
        /# technically, if the user already has an item in their pantry, they should just be updating the quantity with edit
        but they shouldn't be expected to know what they already have. #/
        ingredient = Ingredient.find_by(name: params["ingredient"]["name"])
        if !!ingredient
            users_ingredient = UsersIngredient.find_by(ingredient_id: ingredient.id)
            if !!users_ingredient
                users_ingredient.quantity += params[users_ingredient][quantity]
                users_ingredient.save
            else
                UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: params[users_ingredient][quantity])
            end
        else 
            ingredient = Ingredient.create(params["ingredient"])
            UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: params[users_ingredient][quantity])
        end
        redirect to "/ingredients/list"
    end
end