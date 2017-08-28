require 'rails_helper'

include OmniauthHelpers

describe Users::CreateFromSlackFetch do
  describe '#call' do
    shared_examples 'assign proper attributes to user' do
      it 'assigns proper attributes to user', :aggregate_failures do
        subject
        user.reload
        assert_user(user)
      end
    end

    shared_examples 'call archiver' do
      it 'calls archiver once' do
        allow(Users::ArchiveUser).to receive(:new) { archiver }
        expect(archiver).to receive(:call).once
        subject
      end
    end

    shared_examples 'do not call archiver' do
      it 'does not call archiver' do
        allow(Users::ArchiveUser).to receive(:new) { archiver }
        expect(archiver).not_to receive(:call)
        subject
      end
    end

    shared_examples 'call unarchiver' do
      it 'calls unarchiver once' do
        allow(Users::UnarchiveUser).to receive(:new) { unarchiver }
        expect(unarchiver).to receive(:call).once
        subject
      end
    end

    shared_examples 'do not call unarchiver' do
      it 'does not call unarchiver' do
        allow(Users::UnarchiveUser).to receive(:new) { unarchiver }
        expect(unarchiver).to_not receive(:call)
        subject
      end
    end

    let(:user_info) { users_list_array.first }

    subject { described_class.new(user_info: user_info).call }

    context 'when there is a new user in Slack organisation' do
      it 'assigns proper attributes to user', :aggregate_failures do
        subject
        user = User.last
        assert_user(user)
      end

      it 'creates new user with proper attributes', :aggregate_failures do
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when user has already been in the database', :freeze_time do
      let(:uid) { user_info['id'] }
      let(:email) { user_info['profile']['email'] }

      context 'when user uid matches' do
        let!(:user) { create(:user, uid: uid, name: 'Old Name') }

        include_examples 'assign proper attributes to user'

        it 'does not create new user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when user email matches' do
        let!(:user) { create(:user, email: email, name: 'Old Name') }

        include_examples 'assign proper attributes to user'

        it 'does not create new user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when user email matches but without domain' do
        let!(:user) { create(:user, email: email + 'domain.com', name: 'Old Name') }

        include_examples 'assign proper attributes to user'

        it 'does not create new user' do
          expect { subject }.not_to change(User, :count)
        end

        context 'when user account is archived' do
          let!(:user) { create(:user, email: email + 'domain.com', archived_at: 3.days.ago) }

          include_examples 'assign proper attributes to user'

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end
        end

        context 'when user has two accounts and one is archived' do
          let!(:user_second_account) { create(:user, email: email, archived_at: 3.days.ago) }
          let!(:user_sec_acc_attributes) { user_second_account.attributes.to_s }

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end

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

        it 'does not update user with matching email' do
          subject
          users_attributes = user_with_email.reload.attributes.to_s
          expect(users_attributes).to eq(user_with_email_attributes)
        end
      end

      context 'when archivisation is processed' do
        let(:archiver) { double }
        let(:unarchiver) { double }

        context 'when user is deleted from Slack organisation but not archived yet' do
          let!(:user) { create(:user, uid: uid) }

          before do
            user_info['deleted'] = true
          end

          include_examples 'assign proper attributes to user'
          include_examples 'call archiver'
          include_examples 'do not call unarchiver'

          it 'archives user', :aggregate_failures do
            expect(user.archived_at?).to eq(false)
            subject
            user.reload
            expect(user.archived_at?).to eq(true)
            expect(user.archived_at.to_s).to eq(Time.current.to_s)
          end

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end
        end

        context 'when user is deleted from Slack organisation and already archived' do
          let!(:user) { create(:user, uid: uid, archived_at: 3.days.ago) }

          before do
            user_info['deleted'] = true
          end

          include_examples 'assign proper attributes to user'
          include_examples 'do not call archiver'
          include_examples 'do not call unarchiver'

          it 'does not change user archive status', :aggregate_failures do
            expect(user.archived_at?).to eq(true)
            subject
            user.reload
            expect(user.archived_at?).to eq(true)
          end

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end
        end

        context 'when user is not deleted from Slack organisation and is not archived' do
          let!(:user) { create(:user, uid: uid) }

          include_examples 'assign proper attributes to user'
          include_examples 'do not call archiver'
          include_examples 'do not call unarchiver'

          it 'does not change user archive status', :aggregate_failures do
            expect(user.archived_at?).to eq(false)
            subject
            user.reload
            expect(user.archived_at?).to eq(false)
          end

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end
        end

        context 'when user was deleted from Slack organisation, but is no longer' do
          let!(:user) { create(:user, uid: uid, archived_at: 3.days.ago) }

          include_examples 'assign proper attributes to user'
          include_examples 'do not call archiver'
          include_examples 'call unarchiver'

          it 'unarchives user' do
            subject
            expect(user.reload.archived_at?).to eq(false)
          end

          it 'does not create new user' do
            expect { subject }.not_to change(User, :count)
          end
        end
      end
    end

    context 'when real_name in Slack response is blank' do
      it 'uses mention in place of real name' do
        user_info['real_name'] = ''
        subject
        expect(User.last.name).to eq(user_info['name'])
      end
    end

    context 'when email in Slack response is nil' do
      it 'assigns blank string in place of email' do
        user_info['profile']['email'] = nil
        subject
        expect(User.last.email).to eq('')
      end
    end

    context 'when there is no info in Slack response about admins status' do
      it 'assigns false to #admin' do
        user_info['is_admin'] = nil
        subject
        expect(User.last.admin).to eq(false)
      end
    end

    context 'when user has smaller avatar' do
      it 'uses "original_image" first' do
        user_info['profile']['image_512'] = nil
        subject
        expect(User.last.avatar).to eq(user_info['profile']['image_original'])
      end

      it 'uses "image_192" when no bigger image is available' do
        user_info['profile']['image_512'] = nil
        user_info['profile']['image_original'] = nil
        subject
        expect(User.last.avatar).to eq(user_info['profile']['image_192'])
      end
    end
  end

  private

  def assert_user(user)
    expect(user.provider).to eq('slack')
    expect(user.uid).to eq(user_info['id'])
    expect(user.name).to eq(user_info['real_name'])
    expect(user.email).to eq(user_info['profile']['email'])
    expect(user.admin).to eq(user_info['is_admin'])
    expect(user.avatar).to eq(user_info['profile']['image_512'])
  end
end
