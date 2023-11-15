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

ActiveRecord::Schema[7.0].define(version: 2023_11_15_095000) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genre"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlist_songs", force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "song_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_songs_on_playlist_id"
    t.index ["song_id"], name: "index_playlist_songs_on_song_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "recentyly_playeds", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "song_id", null: false
    t.datetime "played_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_recentyly_playeds_on_song_id"
    t.index ["user_id"], name: "index_recentyly_playeds_on_user_id"
  end

  create_table "share_requests", force: :cascade do |t|
    t.integer "requester_id"
    t.integer "receiver_id"
    t.integer "requested_percent"
    t.string "status", default: "pending"
    t.integer "price"
    t.string "request_type"
    t.integer "split_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["split_id"], name: "index_share_requests_on_split_id"
  end

  create_table "song_requests", force: :cascade do |t|
    t.integer "requester_id"
    t.integer "receiver_id"
    t.integer "requested_percent"
    t.string "status", default: "pending"
    t.integer "price"
    t.integer "song_split_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_split_id"], name: "index_song_requests_on_song_split_id"
  end

  create_table "song_splits", force: :cascade do |t|
    t.integer "requester_id"
    t.integer "receiver_id"
    t.integer "percentage"
    t.integer "song_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_song_splits_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "genre"
    t.integer "user_id", null: false
    t.integer "album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "play_count", default: 0
    t.string "status", default: "public"
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "splits", force: :cascade do |t|
    t.integer "requester_id"
    t.integer "receiver_id"
    t.string "split_type"
    t.integer "percentage", default: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "encrypted_password"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "unconfirmed_email"
    t.string "fav_genre"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "users"
  add_foreign_key "playlist_songs", "playlists"
  add_foreign_key "playlist_songs", "songs"
  add_foreign_key "playlists", "users"
  add_foreign_key "recentyly_playeds", "songs"
  add_foreign_key "recentyly_playeds", "users"
  add_foreign_key "share_requests", "splits"
  add_foreign_key "song_requests", "song_splits"
  add_foreign_key "song_splits", "songs"
  add_foreign_key "songs", "albums"
  add_foreign_key "songs", "users"
end
