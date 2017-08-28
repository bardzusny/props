module Api
  module V1
    module Helpers
      extend Grape::API::Helpers
      include SessionHelpers
      include Pundit

      PERMITED_BOT = 'Slackbot 1.0 (+https://api.slack.com/robots)'.freeze

      def authenticate_user!
        error!('401 Unauthorized', 401) if current_user.nil?
      end

      def authenticate_admin!
        error!('401 Unauthorized', 401) unless current_user.admin?
      end

      def require_api_auth!(token)
        return if current_user.present?
        error!('Invalid token', 401) unless token_valid?(token)
      end

      def token_valid?(token)
        return false if token.nil?
        EasyTokens::Token.exists?(value: token, deactivated_at: nil)
      end

      def require_user_agent!(user_agent)
        message = I18n.t('slack_commands.kudos.errors.wrong_user_agent')
        error!(message, 401) unless permited_bot?(user_agent)
      end

      def permited_bot?(user_agent)
        user_agent == PERMITED_BOT
      end
    end
  end
end
