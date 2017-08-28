require 'rails_helper'

describe Users::ArchiveUser do
  describe '#call', :freeze_time do
    subject { described_class.new(user: user).call }
    let(:user) { create(:user) }

    it 'archives user', :aggregate_failures do
      subject
      expect(user.reload.archived_at?).to eq(true)
      expect(user.archived_at.to_s).to eq(Time.current.to_s)
    end

    it { expect(subject).to be nil }

    context 'when user had a mail subscribtion' do
      let!(:mail_subscription) { create(:mail_subscription, user: user, active: true) }

      it 'removes subscription' do
        subject
        expect(mail_subscription.reload.active).to eq(false)
      end

      it 'does not delete new subscription' do
        expect { subject }.not_to change(MailSubscription, :count)
      end
    end
  end
end
