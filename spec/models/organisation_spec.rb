require 'rails_helper'

RSpec.describe Organisation do
  describe 'associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:users).through(:memberships) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe '#add_user' do
    it 'adds user to the organisation' do
      user = create :user
      organisation = create :organisation

      organisation.add_user(user)

      expect(organisation.reload.users).to eq([user])
    end

    it "doesn't add user to the organisation when already added" do
      user = create :user
      organisation = create :organisation
      organisation.users << user

      organisation.add_user(user)

      expect(organisation.reload.users).to eq([user])
    end
  end
end
