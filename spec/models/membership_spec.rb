require 'rails_helper'

RSpec.describe Membership do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:organisation) }
  end
end
