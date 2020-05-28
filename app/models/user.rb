class User < ActiveRecord::Base
    has_secure_password
    has_many :ingredients, through: :users_ingredients
    has_many :recipes, through: :users_recipes
    # has_and_belongs_to_many :friendships,
    #   class_name: "User", 
    #   join_table:  :friendships, 
    #   foreign_key: :user_id, 
    #   association_foreign_key: :friend_user_id
end