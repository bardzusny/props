require 'rails_helper'

describe Api::V1::SlackCommands do
  let!(:user_1) { create(:user) }
  let!(:user_2) { create(:user, uid: 'U5DH4MX6F') }
  let!(:user_3) { create(:user, uid: '4MX6FU5DH') }
  let!(:organisation) { create(:organisation) }
  let(:path) { '/api/v1/slack_commands/kudos' }

  describe 'POST /api/v1/slack_commands/kudos' do
    subject { post path, params, headers }

    context 'token is invalid' do
      it 'returns unathorized response' do
        post path
        expect(response).to have_http_status(401)
      end
    end

    context 'when user agent is invalid' do
      let!(:api_token) { EasyTokens::Token.create(value: 'aaabbbccc', owner_id: user_1.id) }
      let(:headers) do
        { 'HTTP_USER_AGENT' => 'Invalid User Agent 1.0' }
      end
      let(:params) do
        {
          token: 'aaabbbccc',
          team_id: organisation.team_id,
          user_id: user_1.uid,
          command: '/kudos',
          text: 'some message here <@U5DH4MX6F|hubert>',
        }
      end
      let(:response_message) { '{"error":"Your request was sent from a prohibited device."}' }

      it 'returns unathorized response' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'returns proper response message' do
        subject
        expect(response.body).to eq response_message
      end
    end

    context 'token and user agent are valid' do
      let!(:api_token) { EasyTokens::Token.create(value: 'aaabbbccc', owner_id: user_1.id) }
      let(:headers) do
        { 'HTTP_USER_AGENT' => 'Slackbot 1.0 (+https://api.slack.com/robots)' }
      end
      let(:params) do
        {
          token: 'aaabbbccc',
          team_id: organisation.team_id,
          user_id: user_1.uid,
          command: '/kudos',
          text: 'some message here <@U5DH4MX6F|hubert>',
        }
      end

      context 'when params are valid' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_1.uid,
            command: '/kudos',
            text: 'some message here <@U5DH4MX6F|hubert>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.messages.created')}\"}"
        end

        it 'creates prop' do
          expect { subject }.to change { Prop.count }.from(0).to(1)
        end

        it 'sets prop receivers' do
          subject
          expect(Prop.last.prop_receivers.count).to eq 1
        end

        it 'removes users from message' do
          subject
          expect(Prop.last.body).to eq 'some message here'
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when there are 2 prop receivers' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_1.uid,
            command: '/kudos',
            text: 'some message here <@U5DH4MX6F|susan> <@4MX6FU5DH|john.example>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.messages.created')}\"}"
        end

        it 'creates prop' do
          expect { subject }.to change { Prop.count }.from(0).to(1)
        end

        it 'sets prop receivers' do
          subject
          expect(Prop.last.prop_receivers.count).to eq 2
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when prop receiver is missing' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_1.uid,
            command: '/kudos',
            text: 'some message here',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.errors.prop_receivers_missing')}\"}"
        end

        it 'does not create prop' do
          expect { subject }.not_to change { Prop.count }
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when params are not valid' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: '',
            user_id: '',
            command: '/kudos',
            text: 'some message here <@U5DH4MX6F|susan>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.errors.params_missing')}\"}"
        end

        it 'does not create prop' do
          expect { subject }.not_to change { Prop.count }
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when mentioned user is not present in database' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_1.uid,
            command: '/kudos',
            text: 'some message here <@SL832DXD|terry>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.errors.prop_receivers_missing')}\"}"
        end

        it 'does not create prop' do
          expect { subject }.not_to change { Prop.count }
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when one user is mentioned twice' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_1.uid,
            command: '/kudos',
            text: 'some message here <@U5DH4MX6F|hubert> <@U5DH4MX6F|hubert>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.messages.created')}\"}"
        end

        it 'creates prop' do
          expect { subject }.to change { Prop.count }.from(0).to(1)
        end

        it 'sets prop receivers' do
          subject
          expect(Prop.last.prop_receivers.count).to eq 1
        end

        it 'removes users from message' do
          subject
          expect(Prop.last.body).to eq 'some message here'
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when mentioned user is not present in database' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_2.uid,
            command: '/kudos',
            text: 'some message here <@U5DH4MX6F|hubert>',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.errors.selfpropsing')}\"}"
        end

        it 'does not create prop' do
          expect { subject }.not_to change { Prop.count }
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end

      context 'when asking for help' do
        let(:params) do
          {
            token: 'aaabbbccc',
            team_id: organisation.team_id,
            user_id: user_2.uid,
            command: '/kudos',
            text: 'help',
          }
        end
        let(:message) do
          "{\"text\":\"#{I18n.t('slack_commands.kudos.help')}\"}"
        end

        it 'does not create prop' do
          expect { subject }.not_to change { Prop.count }
        end

        it 'returns message' do
          subject
          expect(response.body).to eq message
        end
      end
    end
  end
end
