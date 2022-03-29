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

ActiveRecord::Schema.define(version: 2022_03_28_125350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "actions", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_option", default: false
  end

  create_table "actions_commitments", force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "action_id"
    t.index ["action_id"], name: "index_actions_commitments_on_action_id"
    t.index ["commitment_id"], name: "index_actions_commitments_on_commitment_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cbd_objectives", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cbd_objectives_criteria", force: :cascade do |t|
    t.bigint "criterium_id"
    t.bigint "cbd_objective_id"
    t.index ["cbd_objective_id"], name: "index_cbd_objectives_criteria_on_cbd_objective_id"
    t.index ["criterium_id"], name: "index_cbd_objectives_criteria_on_criterium_id"
  end

  create_table "commitments", force: :cascade do |t|
    t.boolean "geographic_boundary"
    t.float "latitude"
    t.float "longitude"
    t.integer "current_area_ha"
    t.integer "proposed_area_ha"
    t.string "committed_year"
    t.string "implementation_year"
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
    t.string "related_biodiversity_targets"
    t.string "review_method"
    t.text "responsible_group"
    t.integer "state", default: 0
    t.string "duration_years"
    t.bigint "criterium_id"
    t.bigint "user_id"
    t.boolean "user_created", default: false, null: false
    t.text "area_owner_and_role"
    t.index ["committed_year"], name: "index_commitments_on_committed_year"
    t.index ["country_id"], name: "index_commitments_on_country_id"
    t.index ["duration_years"], name: "index_commitments_on_duration_years"
    t.index ["implementation_year"], name: "index_commitments_on_implementation_year"
  end

  create_table "commitments_countries", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "country_id"
    t.index ["commitment_id"], name: "index_commitments_countries_on_commitment_id"
    t.index ["country_id"], name: "index_commitments_countries_on_country_id"
  end

  create_table "commitments_governance_types", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "governance_type_id"
    t.index ["commitment_id"], name: "index_commitments_governance_types_on_commitment_id"
    t.index ["governance_type_id"], name: "index_commitments_governance_types_on_governance_type_id"
  end

  create_table "commitments_managers", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "manager_id"
    t.index ["commitment_id"], name: "index_commitments_managers_on_commitment_id"
    t.index ["manager_id"], name: "index_commitments_managers_on_manager_id"
  end

  create_table "commitments_objectives", id: false, force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "objective_id"
    t.index ["commitment_id"], name: "index_commitments_objectives_on_commitment_id"
    t.index ["objective_id"], name: "index_commitments_objectives_on_objective_id"
  end

  create_table "commitments_threats", force: :cascade do |t|
    t.bigint "commitment_id"
    t.bigint "threat_id"
    t.index ["commitment_id"], name: "index_commitments_threats_on_commitment_id"
    t.index ["threat_id"], name: "index_commitments_threats_on_threat_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "iso"
    t.float "lat"
    t.float "long"
    t.geography "boundary", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.index ["boundary"], name: "index_countries_on_boundary", using: :gist
  end

  create_table "criteria", force: :cascade do |t|
    t.boolean "boundary", null: false
    t.boolean "five_year_commitment", null: false
    t.boolean "progress_report", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
  end

  create_table "criteria_managers", id: false, force: :cascade do |t|
    t.bigint "criterium_id"
    t.bigint "manager_id"
    t.index ["criterium_id"], name: "index_criteria_managers_on_criterium_id"
    t.index ["manager_id"], name: "index_criteria_managers_on_manager_id"
  end

  create_table "governance_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.text "url", null: false
    t.bigint "commitment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_links_on_commitment_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_option", default: false
    t.index ["name"], name: "index_managers_on_name", unique: true
  end

  create_table "objectives", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_option", default: false
  end

  create_table "post2020_targets", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post2020_targets_commitment_activities", force: :cascade do |t|
    t.bigint "post2020_target_id", null: false
    t.string "commitment_activity_type", null: false
    t.bigint "commitment_activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_activity_type", "commitment_activity_id"], name: "targets_post2020_activities"
    t.index ["post2020_target_id"], name: "post2020_activities_targets"
  end

  create_table "progress_documents", force: :cascade do |t|
    t.bigint "commitment_id"
    t.text "progress_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_progress_documents_on_commitment_id"
  end

  create_table "threats", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_option", default: false
  end

  create_table "threats_and_joins", force: :cascade do |t|
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "commitments", "countries"
end
