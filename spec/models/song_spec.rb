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
      song = FactoryBot.create(:song, title: 'song1', genre: 'lofi', user_id: 1, album_id: 2)
      user = FactoryBot.create(:user)
      song_split = FactoryBot.create(:song_split, receiver_id: artist.id, requester_id: artist.id, song_id: song.id, percentage: 100)
      expect(response.status).to eq(200)
      # song = create(:song)
      # song_split = song.song_splits.first
      
      # expect(song_split.receiver_id).to eql(song.artist_id)
      # expect(song_split.requester_id).to eql(song.artist_id)
      # expect(song_split.song_id).to eql(song.id)
      # expect(song_split.percentage).to eql(100)
    end
  end
  
  # describe 'callbacks' do
  # it 'creates an initial split' do
  #   song = create(:song)
  #   song_split = song.song_splits.first
  
  #   expect(song_split.receiver_id).to eql(song.artist_id)
  #   expect(song_split.requester_id).to eql(song.artist_id)
  #   expect(song_split.song_id).to eql(song.id)
  #   expect(song_split.percentage).to eql(100)
  # end
  # it 'creates an initial song split' do
  #   song = build(:song)
  #   expect(song).to receive(:initial_split)
  #   song.save
  # end
  # it 'set values in split' do
  #   song = create(:song)
  #   song_split = song.song_splits.first
  
  #   expect(song_split.receiver_id).to eql(song.artist_id)
  #   expect(song_split.requester_id).to eql(song.artist_id)
  #   expect(song_split.song_id).to eql(song.id)
  #   expect(song_split.percentage).to eql(100)
  # end
  # end
  
end
