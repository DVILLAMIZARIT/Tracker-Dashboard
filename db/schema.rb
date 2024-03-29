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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111022195349) do

  create_table "project_settings", :force => true do |t|
    t.integer  "tracker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "red_flags_blocked_label",   :default => "blocked",        :null => false
    t.string   "red_flags_unplanned_label", :default => "added_midweek",  :null => false
    t.string   "red_flags_unmet_label",     :default => "ship_this_week", :null => false
  end

  create_table "stories", :force => true do |t|
    t.string   "story_type"
    t.string   "labels"
    t.string   "name"
    t.string   "current_state"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stories_snapshot_id"
    t.integer  "estimate"
  end

  create_table "stories_snapshots", :force => true do |t|
    t.integer  "tracker_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", :force => true do |t|
    t.string   "label"
    t.string   "goal_stories"
    t.string   "goal_points"
    t.integer  "project_settings_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled"
  end

  add_index "tracks", ["project_settings_id"], :name => "index_tracks_on_project_settings_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.boolean  "is_admin",        :default => false
    t.string   "projects_viewed"
    t.integer  "pageviews"
  end

end
