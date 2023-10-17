require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    # let(:user) {build(:user)} #User.new({})
    it {  should validate_presence_of(:username) }
    it {  should validate_presence_of(:email) }
    it {  should validate_presence_of(:password) }
    it {  should have_secure_password }
    it {  should validate_inclusion_of(:user_type).in_array(['Artist', 'Listener'])}
  end
end
