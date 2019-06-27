require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'self.create_with!' do
    let(:authentication) {build(:authentication)}
    let(:new_user) {User.create_with!(authentication, 'Tom')}

    it 'Userが作られること' do
      expect{ new_user }.to change{ User.count }.from(0).to(1)
      expect(User.last).to eq new_user
    end

    it 'Authenticationが作られること' do
      skip 'wip'
    end
  end
end
