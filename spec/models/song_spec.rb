require 'rails_helper'

RSpec.describe Song, type: :model do
  describe "validation" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:genre) }
    it { should validate_inclusion_of(:status).in_array(['public', 'private'])}
  end

  describe "assocaition" do
    it { should have_many(:playlist_songs).dependent(:destroy) }
    it { should have_many(:song_splits).dependent(:destroy)}
    it { should have_many(:playlists).through(:playlist_songs)}
    it { should have_one_attached(:file)}
    it { should belong_to(:album)}
    it { should belong_to(:artist).with_foreign_key('user_id')}
  end
  
  # pending "add some examples to (or delete) #{__FILE__}"
end
