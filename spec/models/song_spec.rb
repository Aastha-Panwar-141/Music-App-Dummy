require 'rails_helper'

RSpec.describe Song, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:genre) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(['public', 'private']) }
  end
  describe 'associations' do
    it { should have_one_attached(:file) }
    it { should belong_to(:artist).with_foreign_key('user_id') }
    it { should belong_to(:album) }
    it { should have_many(:playlist_songs).dependent(:destroy) }
    it { should have_many(:playlists).through(:playlist_songs).dependent(:destroy) }
    it { should have_many(:recentyly_playeds).dependent(:destroy) }
    it { should have_many(:split_requests).with_foreign_key('receiver_id').class_name('SongSplit').dependent(:destroy) }
    it { should have_many(:song_splits).dependent(:destroy) }
  end
  
  describe 'song' do
    # it { is_expected.to callback(:initial_split).after(:create) }
    
    it 'callback' do
      song = FactoryBot.create(:song)
      user = FactoryBot.create(:user, user_type: 'Artist')
      # song_split = SongSplit.create(receiver_id: user.id, requester_id: user.id, song_id: song.id, percentage: 100)
      song_split = FactoryBot.create(:song_split, receiver_id: user.id, requester_id: user.id, song_id: song.id, percentage: 100)
      # expect(response.status).to eq(200)
      # song = create(:song)
      # song_split = song.song_splits.first
      
      # expect(song_split.receiver_id).to eql(song.artist_id)
      # expect(song_split.requester_id).to eql(song.artist_id)
      # expect(song_split.song_id).to eql(song.id)
      # expect(song_split.percentage).to eql(100)
    end
  end
end
