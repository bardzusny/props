require 'rails_helper'
include OmniauthHelpers

describe UsersRepository do
  let(:user) { create(:user, name: 'John Doe', email: 'user@example.com') }
  let(:archived_user) { create(:user, archived_at: Time.now) }
  let(:repo) { described_class.new }

  describe '#find_by_id' do
    it 'returns active user' do
      expect(repo.find_by_id(user.id)).to eq(user)
    end

    it 'returns archived users' do
      expect(repo.find_by_id(archived_user.id)).to eq(archived_user)
    end
  end

  describe '#user_from_auth' do
    let(:new_email) { 'different@email.com' }
    let(:big_avatar) { 'slack.com/big_avatar.png' }
    let(:auth) { create_auth(email: new_email, big_avatar: big_avatar) }

    subject { repo.user_from_auth(auth) }

    it 'returns user object' do
      expect(subject).to eq(User.first)
    end

    context 'when user is already in the database' do
      let!(:user_with_uid) { create(:user, uid: auth['uid']) }

      it "updates user's email when it's different from one in the database" do
        subject
        expect(user_with_uid.reload.email).to eq(new_email)
      end

      it "updates user's avatar when it's different from one in the database" do
        subject
        expect(user_with_uid.reload.avatar).to eq(big_avatar)
      end

      context 'when big avatar in auth hash is nil' do
        let(:small_avatar) { 'slack.com/small_avatar.png' }
        let(:auth) { create_auth(email: new_email, big_avatar: nil, small_avatar: small_avatar) }

        it 'assigns small avatar' do
          subject
          expect(user_with_uid.reload.avatar).to eq(small_avatar)
        end
      end
    end

    context 'when auth is_admin is true' do
      let(:auth) { create_auth(is_admin: true) }

      it 'saves user as admin' do
        subject
        expect(User.first.admin).to eq true
      end
    end

    context 'when auth is_admin is false' do
      let(:auth) { create_auth(is_admin: false) }

      it 'does not save user as admin' do
        subject
        expect(User.first.admin).to eq false
      end
    end
  end

  describe '#user_from_slack' do
    let(:slack_member) do
      {
        'profile' => {
          'email' => email,
          'real_name' => name,
        },
      }
    end

    before do
      AppConfig.stub(:[]).with('domain_name').and_return('example.com')
      AppConfig.stub(:[]).with('extra_domains').and_return('example.co')
      user.reload
    end

    context 'email recieved from slack is matching' do
      let(:email) { 'user@example.com' }
      let(:name) { 'John F Kennedy' }

      it 'returns correct user' do
        expect(repo.user_from_slack(slack_member)).to eq(user)
      end
    end

    context 'local part of email is matching and domain is allowed by extra_domains' do
      let(:email) { 'user@example.co' }
      let(:name) { 'John F Kennedy' }

      it 'returns correct user' do
        expect(repo.user_from_slack(slack_member)).to eq(user)
      end
    end

    context 'email is not reconized' do
      let(:email) { 'wrong@email.co' }

      context 'name is matching' do
        let(:name) { 'John Doe' }

        it 'returns correct user' do
          expect(repo.user_from_slack(slack_member)).to eq(user)
        end
      end

      context 'name is not matching' do
        let(:name) { 'John F Kennedy' }

        subject { repo.user_from_slack(slack_member) }

        it { expect { subject }.to change(User, :count).by(1) }
        it { expect(subject).to eq(User.last) }
        it { expect(subject.email).to eq(email) }
        it { expect(subject.name).to eq(name) }
      end
    end
  end

  describe '#all_users_serialized' do
    let(:organisation) { create(:organisation) }
    let(:expected_result) do
      {
        john.id => serialized_user(john),
        jane.id => serialized_user(jane),
      }
    end

    subject { repo.all_users_serialized(organisation) }

    before do
      organisation.add_user(john)
      organisation.add_user(jane)
    end

    def serialized_user(user)
      {
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'uid' => user.uid,
        'avatar' => user.avatar || Gravatar.new(user.email).image_url(secure: true),
      }
    end

    context 'when users have saved avatars' do
      let!(:john) { create(:user) }
      let!(:jane) { create(:user) }

      it 'returns serialized users with slack avatars' do
        expect(subject).to eq expected_result
      end
    end

    context 'when users do not have saved avatars' do
      let!(:john) { create(:user, avatar: nil) }
      let!(:jane) { create(:user, avatar: nil) }

      it 'returns serialized users with gravatars' do
        expect(subject).to eq expected_result
      end
    end
  end

  describe '#user_serialized' do
    let(:expected_result) do
      {
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'uid' => user.uid,
        'avatar' => user.avatar || Gravatar.new(user.email).image_url(secure: true),
      }
    end

    subject { repo.user_serialized(user) }

    context 'when user has saved avatar' do
      let!(:user) { create(:user) }

      it 'returns serialized user with slack avatar' do
        expect(subject).to eq expected_result
      end
    end

    context 'when user does not have saved avatar' do
      let!(:user) { create(:user, avatar: nil) }

      it 'returns serialized user with gravatar' do
        expect(subject).to eq expected_result
      end
    end
  end
end
