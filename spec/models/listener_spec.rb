require 'rails_helper'

RSpec.describe Listener, type: :model do
  describe "assocaition" do
    it { should have_many(:playlists).with_foreign_key('user_id')}
  end
end
