require 'rails_helper'

include OmniauthHelpers

describe User do
  describe 'associations' do
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:organisations).through(:memberships) }
  end
end
