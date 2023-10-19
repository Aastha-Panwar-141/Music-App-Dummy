require 'rails_helper'

RSpec.describe Album, type: :model do
  describe "validation" do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title)}

  end
  describe "assocaition" do
    it { should have_many(:songs).dependent(:destroy) }
    it { should belong_to(:artist).with_foreign_key('user_id')}
  end
end
