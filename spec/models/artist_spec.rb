require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "assocaition" do
    it { should have_many(:songs).dependent(:destroy).with_foreign_key('user_id') }
    it { should have_many(:albums).dependent(:destroy).with_foreign_key('user_id') }
  end
end
