require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    # let(:user) { build(:user) }
    # let(:user) {build(:user)} #User.new({})
    # it 'should be valid user with all attributes' do
    #   expect(user.valid?).to eq(true)
    # end
    # let - generate a method whose return value is memorize after the first call, no lazy-loading 
    # build - to create instance of user only 

    it {  should validate_presence_of(:username) }
    it {  should validate_uniqueness_of(:username)}
    it {  should validate_presence_of(:email) }
    it {  should validate_uniqueness_of(:email) }
    it {  should validate_presence_of(:password).on(:create) }
    it {  should have_secure_password }
    it {  should validate_inclusion_of(:user_type).in_array(['Artist', 'Listener'])}
  end
  context 'associations' do
    it { should have_many(:playlists).dependent(:destroy) }
    it { should have_many(:recentyly_playeds) }
    it { should have_many(:sent_requests).with_foreign_key(:requester_id).class_name('ShareRequest') }
    it { should have_many(:split_requests).with_foreign_key(:receiver_id).class_name('Split') }
    it { should have_many(:share_requests).dependent(:destroy).with_foreign_key(:receiver_id) }
    it { should have_many(:song_sent_requests).with_foreign_key(:requester_id).class_name('SongRequest') }
    it { should have_many(:followed_users).with_foreign_key(:follower_id).class_name('Follow') }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users).with_foreign_key(:followee_id).class_name('Follow') }
    it { should have_many(:followers).through(:following_users) }
  end
end
