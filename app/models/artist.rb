class Artist < User
    has_many :songs
    has_many :albums
end