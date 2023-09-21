class Listener < User
    has_many :playlists, dependent: :destroy, foreign_key: 'user_id'
end