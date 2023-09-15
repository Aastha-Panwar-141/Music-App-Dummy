class Listener < User
    has_many :playlists
    validates :username, uniqueness: {scope: :type}
end