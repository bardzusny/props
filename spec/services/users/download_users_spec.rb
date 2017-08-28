require 'rails_helper'

include OmniauthHelpers

describe Users::DownloadUsers do
  shared_examples 'do not create users or add them to organisation' do
    it 'does not create a new user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'does not add user to organisation' do
      expect { subject }.not_to change(organisation.users, :count)
    end
  end

  describe '#call' do
    let(:organisation) { create(:organisation) }
    let(:users_list) { double('users_list', members: members) }

    subject { described_class.new(organisation: organisation).call }

    before do
      allow_any_instance_of(Slack::RealTime::Client)
        .to receive_message_chain(:web_client, :users_list) { users_list }
    end

    context 'when there is a new user in Slack organisation' do
      let(:members) { users_list_array(users_number: 1) }

      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'creates new user with proper attributes' do
        subject
        expect(User.last.uid).to eq(members.last['id'])
      end

      it 'adds user to organisation' do
        expect { subject }.to change(organisation.users, :count).by(1)
      end

      context 'when new user is deleted' do
        before { members.first['deleted'] = true }
        include_examples 'do not create users or add them to organisation'
      end
    end

    context 'when there are a few new users in the Slack organisation' do
      let(:members) { users_list_array(users_number: 3) }

      it 'creates a few new users' do
        expect { subject }.to change(User, :count).by(3)
      end

      it 'creates new user with proper attributes', :aggregate_failures do
        subject
        expect(User.first.uid).to eq(members.first['id'])
        expect(User.last.uid).to eq(members.last['id'])
      end

      it 'adds users to organisation' do
        expect { subject }.to change(organisation.users, :count).by(3)
      end
    end

    context 'when a user is a bot' do
      let(:members) { users_list_array(users_number: 2, is_bot: true) }

      include_examples 'do not create users or add them to organisation'

      it 'omits only bot users and creates normal user' do
        members.second['is_bot'] = false
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when a user has "slackbot" name' do
      let(:members) { users_list_array(users_number: 2) }

      before do
        members.each { |member| member['name'] = 'slackbot' }
      end

      include_examples 'do not create users or add them to organisation'

      it 'omits only bot user and creates normal user' do
        members.second['name'] = 'John Doe'
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when a user is a guest' do
      let(:members) { users_list_array(users_number: 2, is_guest: true) }

      include_examples 'do not create users or add them to organisation'

      it 'omits only guest user and creates normal user' do
        members.second['profile']['guest_channels'] = nil
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when a user is restricted' do
      let(:members) { users_list_array(users_number: 2, is_restricted: true) }

      include_examples 'do not create users or add them to organisation'

      it 'omits only guest user and creates normal user' do
        members.second['is_restricted'] = false
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when a user is ultra restricted' do
      let(:members) { users_list_array(users_number: 2, is_ultra_restricted: true) }

      include_examples 'do not create users or add them to organisation'

      it 'omits only guest user and creates normal user' do
        members.second['is_ultra_restricted'] = false
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'when user has already been in the database' do
      let(:members) { users_list_array(users_number: 1) }
      let(:uid) { members.first['id'] }
      let(:email) { members.first['profile']['email'] }
      let(:user) do
        create(:user, uid: uid, email: email, name: 'Old Name')
      end
      let(:organisation) { create(:organisation, users: [user]) }

      it 'updates user data', :aggregate_failures do
        expect(organisation.users.last.name).to eq(user.name)
        subject
        expect(user.reload.name).to eq(members.first['real_name'])
      end
    end

    context 'when a user is deleted from the Slack organisation' do
      let(:members) { users_list_array(users_number: 1) }

      before do
        members.first['deleted'] = true
      end

      it 'does not add user to organisation' do
        expect { subject }.not_to change(organisation.users, :count)
      end
    end

    context 'when there are a few organisations' do
      let(:members) { users_list_array(users_number: 1) }
      let(:uid) { members.first['id'] }
      let(:email) { members.first['profile']['email'] }
      let(:user_one) do
        create(:user, uid: uid, email: email, name: 'Old Name')
      end
      let(:user_two) { create(:user, name: 'Other Name') }
      let!(:organisation_one) { create(:organisation, users: [user_one]) }
      let!(:organisation_two) { create(:organisation, users: [user_two]) }

      subject { described_class.new(organisation: organisation_one).call }

      it 'updates user data', :aggregate_failures do
        expect(organisation_one.users.last.name).to eq(user_one.name)
        subject
        expect(user_one.reload.name).to eq(members.first['real_name'])
      end

      it 'updates users only from provided orgaisation', :aggregate_failures do
        expect(organisation_two.users.last.name).to eq(user_two.name)
        subject
        expect(user_two.reload.name).to eq(user_two.name)
      end
    end
  end
end
