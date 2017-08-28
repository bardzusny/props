shared_context 'a successful JSON request' do
  it 'returns an OK (200) status code' do
    expect(response.status).to eq(200)
    expect(response.content_type).to eq 'application/json'
  end
end

shared_context 'token accessible api' do
  let(:path) { '' }
  let(:method) { :get }
  let(:params) { {} }
  let(:membership) { create(:membership) }
  let(:user) { membership.user }
  let(:expected_status) { 200 }
  let!(:token) { EasyTokens::Token.create(value: 'secret_token', owner: membership) }
  let(:request) { send(method, path + '?api_key=secret_token', params) }

  it 'returns unathorized response' do
    request
    expect(response).to have_http_status(expected_status)
  end
end
