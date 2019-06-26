require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'self.create_with!' do
    let(:authentication) {build(:authentication)}
    before do
      User.create_with!(authentication, 'Tom')
    end

    it 'Userが作られること' do
      user = User.last
      expect(user.name).to eq 'Tom'
    end

    it 'Authenticationが作られること' do
      skip 'wip'
    end
  end
end
