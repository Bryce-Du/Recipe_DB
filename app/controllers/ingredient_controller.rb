class IngredientController < ApplicationController
    get "/ingredients" do
        @users_ingredients = UsersIngredient.all.select{|i| i.user_id == current_user.id}
        erb :"/ingredients/list"
    end
    get "/ingredients/new" do 
        erb :"/ingredients/new"
    end
    get "/ingredients/browse" do
        @ingredients = Ingredient.all
        erb :"/browse/ingredients"
    end
    get "/ingredients/:id" do
        @ingredient = Ingredient.find(params[:id])
        @users_ingredient = UsersIngredient.where(ingredient_id: @ingredient.id).find_by(user_id: current_user.id)
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
        ingredients = params["ingredient"]
        ingredients.each_with_index do |ingredient_hash, index|
            if ingredient_hash["name"] != "" # don't add from blank inputs
                quantity = params["users_ingredient"][index]["quantity"].to_i
                ingredient = Ingredient.find_by(name: ingredient_hash["name"])
                if !!ingredient
                    users_ingredient = UsersIngredient.find_by(ingredient_id: ingredient.id)
                    if !!users_ingredient
                        users_ingredient.quantity += quantity
                        users_ingredient.save
                    else
                        UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: quantity)
                    end
                else 
                    ingredient = Ingredient.create(ingredient_hash)
                    UsersIngredient.create(user_id: current_user.id, ingredient_id: ingredient.id, quantity: quantity)
                end
            end
        end
        redirect to "/ingredients"
    end
    post "/ingredients/:id/add" do
        UsersIngredient.create(ingredient_id: params[:id], user_id: current_user.id, quantity: params["quantity"])
        redirect to "/ingredients"
    end
    patch "/ingredients/:id/edit" do
        @ingredient = Ingredient.find(params[:id])
        @users_ingredient = UsersIngredient.where(:user_id=>current_user.id).find_by(:ingredient_id=>params[:id])
        if params["users_ingredient"]["quantity"].to_i == 0 # if quantity reduced to zero, remove from pantry
            UsersIngredient.delete(UsersIngredient.where(:user_id=>current_user.id).find_by(:ingredient_id=>params[:id]).id)
        else
            @users_ingredient.update(params["users_ingredient"])
        end
        @ingredient.update(params["ingredient"])
        redirect to "/ingredients"
    end
    delete "/ingredients/:id/remove" do
        UsersIngredient.delete(UsersIngredient.where(:user_id=>current_user.id).find_by(:ingredient_id=>params[:id]).id)
        redirect to "/ingredients"
    end
    delete "/ingredients/:id/destroy" do
        if current_user == User.find_by(username: "admin")
            UsersIngredient.delete(UsersIngredient.where(ingredient_id: params[:id]).map{|i| i.id}) # delete users references to this ingredient
            RecipesIngredient.delete(RecipesIngredient.where(ingredient_id: params[:id]).map{|i| i.id}) # delete recipes references to this ingredient
            Ingredient.destroy(params[:id])
        end
        redirect to "/ingredients"
    end
end