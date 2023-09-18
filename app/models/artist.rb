class Artist < User
    has_many :songs, dependent: :destroy, foreign_key: 'user_id'
    has_many :albums, dependent: :destroy, foreign_key: 'user_id'
end