require 'rails_helper'

describe Api::V1::Rankings do
  let(:propser) { create(:user) }
  let(:receiver) { create(:user) }
  let!(:organisation) { create(:organisation) }
  let!(:membership_one) { create(:membership, user: propser, organisation: organisation) }
  let!(:membership_two) { create(:membership, user: receiver, organisation: organisation) }
  let(:prop_receiver) { PropReceiver.create(user: receiver) }
  let!(:prop) do
    Prop.create(body: 'sample', propser: propser,
                prop_receivers: [prop_receiver],
                organisation: organisation)
  end
  let!(:api_token) { EasyTokens::Token.create(value: 'aaabbbccc', owner_id: propser.id) }

  describe 'GET /api/v1/rankings/hero_of_the_week' do
    context 'with invalid api token' do
      let(:token) { 'cccbbbaaa' }

      before do
        get '/api/v1/rankings/hero_of_the_week', token: token
      end

      it "returns 'Invalid token' response" do
        result = json_response['error']
        expect(result).to eq 'Invalid token'
      end
    end

    context 'with valid api token' do
      let(:token) { api_token.value }

      before do
        sign_in(membership_one)
        get '/api/v1/rankings/hero_of_the_week', token: token
      end

      after do
        sign_out
      end

      it 'returns user with the most received props' do
        expect(json_response['user']).to eq receiver.name
        expect(json_response['kudos_count']).to eq 1
      end
    end
  end

  describe 'GET /api/v1/rankings/top_kudosers' do
    context 'with invalid api token' do
      let(:token) { 'cccbbbaaa' }

      it "returns 'Invalid token' response" do
        get '/api/v1/rankings/top_kudosers', token: token
        result = json_response['error']
        expect(result).to eq 'Invalid token'
      end
    end

    context 'with valid api token' do
      let(:token) { api_token.value }

      before do
        sign_in(membership_one)
      end

      after do
        sign_out
      end

      context 'without time_range param' do
        it "returns 'time_range is missing' response" do
          get '/api/v1/rankings/top_kudosers', token: token
          result = json_response['error']
          expect(result).to eq 'time_range is missing'
        end
      end

      context 'with time_range param' do
        let(:time_range) { 'weekly' }

        it 'returns user with the most received props' do
          get '/api/v1/rankings/top_kudosers', token: token, time_range: time_range
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET /api/v1/rankings/team_activity' do
    context 'with invalid api token' do
      let(:token) { 'cccbbbaaa' }

      it "returns 'Invalid token' response" do
        get '/api/v1/rankings/team_activity', token: token
        result = json_response['error']
        expect(result).to eq 'Invalid token'
      end
    end

    context 'with valid api token' do
      let(:token) { api_token.value }

      before do
        sign_in(membership_one)
      end

      after do
        sign_out
      end

      context 'without time_range param' do
        it "returns 'time_range is missing' response" do
          get '/api/v1/rankings/team_activity', token: token
          result = json_response['error']
          expect(result).to eq 'time_range is missing'
        end
      end

      context 'with time_range param' do
        let(:time_range) { 'weekly' }

        it 'returns user with the most received props' do
          get '/api/v1/rankings/team_activity', token: token, time_range: time_range
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET /api/v1/rankings/kudos_streak' do
    context 'with invalid api token' do
      let(:token) { 'cccbbbaaa' }

      it "returns 'Invalid token' response" do
        get '/api/v1/rankings/kudos_streak', token: token
        result = json_response['error']
        expect(result).to eq 'Invalid token'
      end
    end

    context 'with valid api token' do
      let(:token) { api_token.value }

      before do
        sign_in(membership_one)
      end

      after do
        sign_out
      end

      context 'without time_range param' do
        it "returns 'time_range is missing' response" do
          get '/api/v1/rankings/kudos_streak', token: token
          result = json_response['error']
          expect(result).to eq 'time_range is missing'
        end
      end

      context 'with time_range param' do
        let(:time_range) { 'weekly' }

        it 'returns user with the most received props' do
          get '/api/v1/rankings/kudos_streak', token: token, time_range: time_range
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
