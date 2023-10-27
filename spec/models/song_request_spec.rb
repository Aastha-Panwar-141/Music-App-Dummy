require 'rails_helper'

RSpec.describe SongRequest, type: :model do
  describe "assocaition" do
    it { should belong_to(:song_split)}
    it { should belong_to(:requester).with_foreign_key('requester_id')}
    it { should belong_to(:receiver).with_foreign_key('receiver_id')}
  end
  
  describe "validation" do
    it { should validate_inclusion_of(:status).in_array(%w[pending accepted rejected closed]) }
  end
  
  # pending "add some examples to (or delete) #{__FILE__}"
end
