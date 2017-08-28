require 'rails_helper'

include OmniauthHelpers

describe Users::SignIn do
  describe '#call' do
    it 'returns object with user_id and organisation_id' do
      auth = create_auth
      sign_in = Users::SignIn.new(auth: auth)

      membership = sign_in.call

      expect(membership.user_id).to eq(User.first.id)
      expect(membership.organisation_id).to eq(Organisation.first.id)
    end

    it 'adds user to the organisation' do
      auth = create_auth
      sign_in = Users::SignIn.new(auth: auth)

      sign_in.call

      expect(Organisation.first.users).to include(User.first)
    end

    it "updates user's email when it's different from one in the database" do
      new_email = 'different@email.com'
      auth = create_auth(email: new_email)
      user = create(:user,
                    email: 'some@email.com',
                    provider: auth['provider'], uid: auth['uid'])
      sign_in = Users::SignIn.new(auth: auth)

      sign_in.call

      expect(user.reload.email).to eq(new_email)
    end

    it 'saves authenitcation token when organisation is created' do
      token = 'some_token'
      auth = create_auth(token: token)
      sign_in = Users::SignIn.new(auth: auth)

      sign_in.call

      expect(Organisation.first.token).to eq(token)
    end

    it 'saves user as admin if is_admin is true' do
      auth = create_auth(is_admin: true)
      sign_in = Users::SignIn.new(auth: auth)

      sign_in.call

      expect(User.first.admin).to eq true
    end

    it 'does not save user as admin if is_admin is false' do
      auth = create_auth(is_admin: false)
      sign_in = Users::SignIn.new(auth: auth)

      sign_in.call

      expect(User.first.admin).to eq false
    end
  end
end
