class IngredientController < ApplicationController
    get "/ingredients" do
        @users_ingredients = UsersIngredient.all.map{|i| i.user_id == current_user.id}
        erb :"/ingredients/list"
    end
    get "/ingredients/new" do 
        erb :"/ingredients/new"
    end
    post "/ingredients/new" do
        ingredient = Ingredient.find_or_create_by_name(params["ingredient"]["name"])
        ingredient.calories ||= params["ingredient"]["calories"] # if ingredient already exists, don't update calories, should be changed in edit instead.
        ingredient.save
        
    end
end