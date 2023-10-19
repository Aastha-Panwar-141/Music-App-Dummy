require 'rails_helper'

RSpec.describe Playlist, type: :model do
  describe "validation" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title)}
  end

  describe "assocaition" do
    it { should have_many(:playlist_songs).dependent(:destroy) }
    it { should have_many(:songs).through(:playlist_songs)}
    it { should belong_to(:listener).with_foreign_key('user_id')}
  end
end
