require 'rails_helper'

describe Api::V1::Props do
  let(:membership) { create(:membership) }
  let(:user) { membership.user }
  let(:organisation) { membership.organisation }
  let(:receivers) { create_list(:user, 3) }

  describe 'GET /api/v1/props' do
    context 'user is a guest' do
      it 'returns unathorized response' do
        get '/api/v1/props'
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      let(:params) { { propser_id: user.id }.as_json }
      let!(:props) { create_list(:prop, 2, propser: user, organisation: organisation) }

      before do
        sign_in(membership)
        get '/api/v1/props', params
      end

      after { sign_out }

      it 'returns search result' do
        results = json_response['props']
        expect(results.class).to be Array
        expect(results.count).to eq 2
      end

      it 'returns meta key with pagination data' do
        results = json_response['meta']
        expect(results['current_page']).to eq 1
        expect(results['total_count']).to eq 2
        expect(results['total_pages']).to eq 1
      end
    end
  end

  describe 'GET /api/v1/props/total' do
    include_context 'token accessible api' do
      let(:path) {  '/api/v1/props/total' }
    end

    context 'user is a guest' do
      it 'returns unathorized response' do
        get '/api/v1/props/total'
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      let!(:props) { create_list(:prop, 3, propser: user, organisation: organisation) }

      before do
        sign_in(membership)
        get '/api/v1/props/total'
      end

      after { sign_out }

      it 'returns props count' do
        expect(json_response).to eq 3
      end
    end
  end

  describe 'POST /api/v1/props' do
    let(:prop_params) { { user_ids: receivers.map(&:id).join(','), body: 'sample text' }.as_json }

    include_context 'token accessible api' do
      let(:path) { '/api/v1/props' }
      let(:method) { :post }
      let(:params) { prop_params }
      let(:expected_status) { 201 }
    end

    context 'user is a guest' do
      it 'returns unathorized response' do
        post '/api/v1/props'
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      before do
        sign_in(membership)
        allow_any_instance_of(Notifier::SlackNotifier).to receive(:notify).and_return(double(ping: true))
        post '/api/v1/props', prop_params
      end

      after { sign_out }

      context 'with valid attributes' do
        it 'returns success' do
          expect(response).to have_http_status(:success)
        end

        it 'adds new prop to database' do
          expect(Prop.all.count).to eq 1
          expect(Prop.first.body).to eq 'sample text'
        end
      end
    end
  end

  describe 'POST /api/v1/props/:prop_id/upvotes' do
    let(:prop) { create(:prop) }

    include_context 'token accessible api' do
      let(:path) { "/api/v1/props/#{prop.id}/upvotes" }
      let(:method) { :post }
      let(:expected_status) { 201 }
    end

    context 'user is a guest' do
      it 'returns unathorized response' do
        post "/api/v1/props/#{prop.id}/upvotes"
        expect(response).to have_http_status(401)
      end
    end

    context 'user is signed in' do
      before { sign_in(membership) }
      after { sign_out }

      it 'increases prop upvotes count by 1' do
        post "/api/v1/props/#{prop.id}/upvotes"
        expect(json_response['upvotes_count']).to eq 1
      end
    end
  end

  describe 'DELETE /api/v1/props/:prop_id/undo_upvotes' do
    let(:prop) { create(:prop) }
    let(:membership2) { create(:membership) }
    let(:upvote) { create(:upvote, prop: prop, user: user2) }

    context 'user is a guest' do
      it 'returns unathorized response' do
        delete "/api/v1/props/#{prop.id}/undo_upvotes"
        expect(response).to have_http_status(401)
      end
    end

    context 'user tries to undo upvote of different user' do
      before { sign_in(membership2) }
      after { sign_out }

      it 'undoes the upvote' do
        delete "/api/v1/props/#{prop.id}/undo_upvotes"
        expect(json_response['errors']).to eq(I18n.t('props.errors.no_upvote'))
      end
    end
    context 'user undoes own upvote' do
      before { sign_in(membership) }
      after { sign_out }

      it 'undoes the upvote' do
        delete "/api/v1/props/#{prop.id}/undo_upvotes"
        expect(json_response['errors']).to eq(I18n.t('props.errors.no_upvote'))
      end
    end
  end
end
