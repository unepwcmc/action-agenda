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

ActiveRecord::Schema.define(version: 2022_01_20_130432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "related_biodiversity_targets"
    t.string "review_method"
    t.text "responsible_group"
    t.integer "state", default: 0
    t.integer "duration_years"
    t.bigint "criterium_id"
    t.index ["country_id"], name: "index_commitments_on_country_id"
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
  end

  create_table "criteria", force: :cascade do |t|
    t.boolean "boundary", null: false
    t.boolean "five_year_commitment", null: false
    t.boolean "progress_report", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria_stakeholders", force: :cascade do |t|
    t.bigint "criterium_id"
    t.bigint "stakeholder_id"
    t.index ["criterium_id"], name: "index_criteria_stakeholders_on_criterium_id"
    t.index ["stakeholder_id"], name: "index_criteria_stakeholders_on_stakeholder_id"
  end

  create_table "governance_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.text "name"
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

  create_table "progress_documents", force: :cascade do |t|
    t.bigint "commitment_id"
    t.text "progress_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_progress_documents_on_commitment_id"
  end

  create_table "stakeholders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "threats", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_option", default: false
  end

  create_table "threats_and_joins", force: :cascade do |t|
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "commitments", "countries"
end
