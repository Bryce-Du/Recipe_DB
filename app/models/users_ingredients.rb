class UsersIngredient < ActiveRecord::Base
    belongs_to :user
    belongs_to :ingredient
end