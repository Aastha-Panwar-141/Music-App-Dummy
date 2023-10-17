require 'rails_helper'

RSpec.describe SongSplit, type: :model do
  describe "assocaition" do
    it { should have_many(:song_requests).dependent(:destroy) }
    it { should belong_to(:song)}
    it { should belong_to(:requester).with_foreign_key('requester_id')}
    it { should belong_to(:receiver).with_foreign_key('receiver_id')}
  end
end
