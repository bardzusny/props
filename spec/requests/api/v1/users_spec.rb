require 'rails_helper'

include OmniauthHelpers

describe Api::V1::Users do
  let!(:users) { create_list(:user, 2) }
  let(:membership) { create(:membership, user: users[0]) }

  describe 'GET /api/v1/users' do
    include_context 'token accessible api' do
      let(:path) { '/api/v1/users' }
    end

    context 'user is a guest' do
      it 'returns unathorized response' do
        get '/api/v1/users'
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      before do
        sign_in(membership)
        get '/api/v1/users'
      end

      after { sign_out }

      it 'returns all active users for current organisation', :aggregate_failures do
        expect(json_response.class).to be Array
        expect(json_response.size).to eq(
          UsersRepository.new.for_organisation(membership.organisation).count,
        )
      end
    end
  end

  describe 'GET /api/v1/users/:user_id' do
    include_context 'token accessible api' do
      let(:path) { "/api/v1/users/#{user.id}" }
    end

    context 'user is a guest' do
      it 'returns unathorized response' do
        get "/api/v1/users/#{users[0].id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      it 'returns specific user' do
        membership = create :membership
        user = create(:user)
        membership.organisation.users << user
        sign_in(membership)

        get "/api/v1/users/#{user.id}"

        expect(json_response['name']).to eq user.name

        sign_out
      end

      it 'returns forbidden status when accessing user in different organisation' do
        sign_in(create(:membership))
        user_in_different_organisation = create :user
        organisation_b = create :organisation
        organisation_b.users << user_in_different_organisation

        get "/api/v1/users/#{user_in_different_organisation.id}"

        expect(response).to have_http_status(403)

        sign_out
      end
    end
  end

  describe 'POST /api/v1/users/download_users' do
    context 'when user is a guest' do
      it 'returns unathorized response' do
        post '/api/v1/users/download_users'
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is signed in but not as an admin' do
      before do
        sign_in(membership)
        post '/api/v1/users/download_users'
      end

      after { sign_out }

      it 'returns unathorized response' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when admin is signed in' do
      let(:organisation) { create(:organisation) }
      let(:admin) { create(:user, admin: true) }
      let(:membership) { create(:membership, user: admin, organisation: organisation) }
      let(:users_list) { double('users_list', members: members) }
      let(:members) { users_list_array(users_number: 1) }
      let(:response_body) do
        { text: 'Processing in the background' }
      end
      let(:redirection_msg) { 'This resource has been moved temporarily to /app/users.' }

      before do
        allow_any_instance_of(Slack::RealTime::Client)
          .to receive_message_chain(:web_client, :users_list) { users_list }
        sign_in(membership)
        post '/api/v1/users/download_users'
      end

      after { sign_out }

      it 'has OK response status' do
        expect(response).to have_http_status(302)
        # 302 because of redirection - see explanation in the controller
        # expect(response).to have_http_status(201)
      end

      it 'has proper response body' do
        expect(response.body).to eq(redirection_msg.to_json)
        # Changed because of redirection - see explanation in the controller
        # expect(response.body).to eq(response_body.to_json)
      end
    end
  end
end
