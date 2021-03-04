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

ActiveRecord::Schema.define(version: 2021_03_04_132343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "actors_commitments", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "actor_id"
    t.index ["actor_id"], name: "index_actors_commitments_on_actor_id"
    t.index ["commitment_id"], name: "index_actors_commitments_on_commitment_id"
  end

  create_table "commitments", force: :cascade do |t|
    t.boolean "geographic_boundary"
    t.float "latitude"
    t.float "longitude"
    t.integer "current_area_ha"
    t.integer "proposed_area_ha"
    t.integer "committed_year"
    t.integer "implementation_year"
    t.integer "update_year"
    t.text "name"
    t.text "governance_authority"
    t.text "planned_actions"
    t.text "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.string "duration"
    t.string "stage"
    t.string "governance_type"
    t.string "related_biodiversity_targets"
    t.string "review_method"
    t.index ["country_id"], name: "index_commitments_on_country_id"
  end

  create_table "commitments_objectives", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "objective_id"
    t.index ["commitment_id"], name: "index_commitments_objectives_on_commitment_id"
    t.index ["objective_id"], name: "index_commitments_objectives_on_objective_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "iso"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "commitments", "countries"
end
