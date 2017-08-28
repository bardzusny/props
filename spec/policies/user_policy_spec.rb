require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  permissions :show? do
    it 'grants access if user is in the same organisation as current membership' do
      user = create :user
      membership = create :membership
      membership.organisation.users << user

      expect(subject).to permit(membership, user)
    end

    it 'denies access if user is not in the same organisation as current membership' do
      user = create :user
      membership = create :membership

      expect(subject).not_to permit(membership, user)
    end
  end
end
