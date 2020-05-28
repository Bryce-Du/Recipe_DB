# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200528134433) do

  create_table "ingredients", force: :cascade do |t|
    t.string  "name"
    t.integer "calories"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.string "instructions"
  end

  create_table "recipes_ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
    t.integer "quantity"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
  end

  create_table "users_ingredients", force: :cascade do |t|
    t.integer "user_id"
    t.integer "ingredient_id"
  end

  create_table "users_recipes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
  end

end
