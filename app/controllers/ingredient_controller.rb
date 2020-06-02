class IngredientController < ApplicationController
    get "/ingredients" do
        @users_ingredients = UsersIngredient.all.select{|i| i.user_id == current_user.id}
        erb :"/ingredients/list"
    end
    get "/ingredients/new" do 
        erb :"/ingredients/new"
    end
    get "/ingredients/:id" do
        @ingredient = Ingredient.find(params[:id])
        erb :"ingredients/show"
    end
    get "/ingredients/:id/edit" do
        @ingredient = Ingredient.find(params[:id])
        @users_ingredient = UsersIngredient.where(:user_id=>current_user.id).where(:ingredient_id=>params[:id]).first
        erb :"ingredients/edit"
    end
    post "/ingredients/new" do
        /# technically, if the user already has an item in their pantry, they should just be updating the quantity with edit
        but they shouldn't be expected to know what they already have. #/
        ingredient = Ingredient.find_by(name: params["ingredient"]["name"])
        if !!ingredient
            users_ingredient = UsersIngredient.find_by(ingredient_id: ingredient.id)
            if !!users_ingredient
                users_ingredient.quantity += params["users_ingredient"]["quantity"].to_i
                users_ingredient.save
            else
                UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: params["users_ingredient"]["quantity"])
            end
        else 
            ingredient = Ingredient.create(params["ingredient"])
            UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: params["users_ingredient"]["quantity"])
        end
        redirect to "/ingredients"
    end
    patch "/ingredients/:id/edit" do
        @ingredient = Ingredient.find(params[:id])
        @users_ingredient = UsersIngredient.where(:user_id=>current_user.id).where(:ingredient_id=>params[:id]).first
        @users_ingredient.update(params["users_ingredient"])
        @ingredient.update(params["ingredient"])
        redirect to "/ingredients"
    end
end