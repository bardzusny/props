require 'rails_helper'

include OmniauthHelpers

describe Users::CreateFromOmniauth do
  describe '#call' do
    shared_examples 'assign proper attributes to user' do
      it 'assigns proper attributes to user', :aggregate_failures do
        subject
        user.reload
        assert_user(user)
      end
    end

    shared_examples 'not create new user and return user object' do
      it 'does not create new user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'returns user object' do
        expect(subject).to eq(user.reload)
      end
    end

    let(:auth) { create_auth }
    subject { described_class.new(auth: auth).call }

    context 'when there is a new user in Slack organisation' do
      it 'assigns proper attributes to user', :aggregate_failures do
        subject
        user = User.last
        assert_user(user)
      end

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'returns user object' do
        expect(subject).to eq(User.last)
      end
    end

    context 'when user has already been in the database', :freeze_time do
      let(:uid) { auth['uid'] }
      let(:email) { auth['info']['email'] }

      context 'when user uid matches' do
        let!(:user) { create(:user, uid: uid, name: 'Old Name') }

        include_examples 'assign proper attributes to user'
        include_examples 'not create new user and return user object'
      end

      context 'when user email matches' do
        let!(:user) { create(:user, email: email, name: 'Old Name') }

        include_examples 'assign proper attributes to user'
        include_examples 'not create new user and return user object'
      end

      context 'when user email matches but without domain' do
        let!(:user) { create(:user, email: email + 'domain.com', name: 'Old Name') }

        include_examples 'assign proper attributes to user'
        include_examples 'not create new user and return user object'

        context 'when user account is archived' do
          let!(:user) { create(:user, email: email + 'domain.com', archived_at: 3.days.ago) }

          include_examples 'assign proper attributes to user'
          include_examples 'not create new user and return user object'
        end

        context 'when user has two accounts and one is archived' do
          let!(:user_second_account) { create(:user, email: email, archived_at: 3.days.ago) }
          let!(:user_sec_acc_attributes) { user_second_account.attributes.to_s }

          include_examples 'not create new user and return user object'

          it 'does not update archived account' do
            subject
            users_attributes = user_second_account.reload.attributes.to_s
            expect(users_attributes).to eq(user_sec_acc_attributes)
          end
        end
      end

      context 'when both uid and email without domain matches' do
        let!(:user) { create(:user, uid: uid) }
        let!(:user_with_email) { create(:user, email: email + 'domain.com') }
        let!(:user_with_email_attributes) { user_with_email.attributes.to_s }

        include_examples 'assign proper attributes to user'
        include_examples 'not create new user and return user object'

        it 'does not update user with matching email' do
          subject
          users_attributes = user_with_email.reload.attributes.to_s
          expect(users_attributes).to eq(user_with_email_attributes)
        end
      end
    end

    context 'when real_name in Slack response is blank' do
      it 'uses name in place of real name' do
        auth['extra']['user_info']['user']['profile']['real_name'] = nil
        subject
        expect(User.last.name).to eq(auth['info']['name'])
      end
    end

    context 'when real_name and name in Slack response is blank' do
      it 'does not update user - raises validation error' do
        auth['extra']['user_info']['user']['profile']['real_name'] = nil
        auth['info']['name'] = nil
        expect { subject }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end

    context 'when email in Slack response is nil' do
      it 'assigns blank string in place of email' do
        auth['info']['email'] = nil
        subject
        expect(User.last.email).to eq('')
      end
    end

    context 'when there is no info in Slack response about admins status' do
      it 'assigns false to #admin' do
        auth['info']['is_admin'] = nil
        subject
        expect(User.last.admin).to eq(false)
      end
    end

    context 'when user has smaller avatar' do
      it 'uses "image_192" when no bigger image is available' do
        auth['extra']['user_info']['user']['profile']['image_512'] = nil
        subject
        expect(User.last.avatar).to eq(auth['info']['image'])
      end
    end
  end

  private

  def assert_user(user)
    expect(user.provider).to eq('slack')
    expect(user.uid).to eq(auth['uid'])
    expect(user.name).to eq(auth.dig('extra', 'user_info', 'user', 'profile', 'real_name'))
    expect(user.email).to eq(auth['info']['email'])
    expect(user.admin).to eq(auth['info']['is_admin'])
    expect(user.avatar).to eq(auth.dig('extra', 'user_info', 'user', 'profile', 'image_512'))
  end
end
