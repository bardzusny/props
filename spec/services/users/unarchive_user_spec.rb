require 'rails_helper'

describe Users::UnarchiveUser do
  describe '#call' do
    subject { described_class.new(user: user).call }
    let(:user) { create(:user, archived_at: Time.current) }

    it 'unarchives user' do
      subject
      expect(user.reload.archived_at?).to eq(false)
    end

    it 'returns user object' do
      expect(subject).to eq(user.reload)
    end

    context 'when user had a mail subscribtion' do
      let!(:mail_subscription) { create(:mail_subscription, user: user, active: false) }

      it 'restores subscription' do
        subject
        expect(mail_subscription.reload.active).to eq(true)
      end

      it 'does not create new subscription' do
        expect { subject }.not_to change(MailSubscription, :count)
      end
    end
  end
end
