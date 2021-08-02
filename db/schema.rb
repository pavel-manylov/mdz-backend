# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_31_134432) do

  create_table "boolean_values", force: :cascade do |t|
    t.boolean "value", default: false, null: false
    t.boolean "draft_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "components", force: :cascade do |t|
    t.integer "post_id", null: false
    t.string "value_type"
    t.integer "value_id"
    t.boolean "public", default: true, null: false
    t.string "display_class"
    t.integer "order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_components_on_post_id"
    t.index ["value_type", "value_id"], name: "index_components_on_value"
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "draft", default: true, null: false
    t.string "seo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "relation_value_posts", force: :cascade do |t|
    t.integer "relation_value_id"
    t.integer "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_relation_value_posts_on_post_id"
    t.index ["relation_value_id"], name: "index_relation_value_posts_on_relation_value_id"
  end

  create_table "relation_values", force: :cascade do |t|
    t.boolean "has_draft_value", default: false, null: false
    t.boolean "has_value", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "string_values", force: :cascade do |t|
    t.text "value", default: "f", null: false
    t.text "draft_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
