require 'rails_helper'

describe UserPropsRepository do
  let(:user) { create(:user) }
  let(:organisation) { create(:organisation) }
  let(:repo) { described_class.new user, organisation }

  describe '#given' do
    it 'returns given props' do
      prop = create :prop, propser: user, organisation: organisation
      expect(repo.given).to eq [prop]
    end
  end

  describe '#received' do
    it 'returns received props' do
      prop = create :prop, organisation: organisation
      prop.users << user
      expect(repo.received).to eq [prop]
    end
  end
end
