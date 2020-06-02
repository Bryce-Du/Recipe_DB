class RecipeController < ApplicationController
    get "/recipes" do
        @users_recipes = UsersRecipe.all.select{|i| i.user_id == current_user.id}
        erb :"/recipes/list"
    end
    get "/recipes/new" do 
        erb :"/recipes/new"
    end
    post "/recipes/new" do
        binding.pry
    end
end