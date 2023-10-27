require 'rails_helper'

RSpec.describe Split, type: :model do
  describe "assocaition" do
    it { should have_many(:share_requests).dependent(:destroy) }
    it { should belong_to(:requester).with_foreign_key('requester_id')}
    it { should belong_to(:receiver).with_foreign_key('receiver_id')}
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
