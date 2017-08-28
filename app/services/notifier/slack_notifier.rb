class Notifier
  class SlackNotifier < Base
    private

    def notify
      response = channel.chat_postMessage(message)
      notification.prop.update(slack_ts: response[:ts])
    rescue Slack::Web::Api::Error => err
      Rollbar.error "Sending slack notifaction failed. Reason: #{err}"
    end

    def channel
      @channel ||= Slack::RealTime::Client.new(token: token).web_client
    end

    def token
      @token ||= notification.prop.organisation.token
    end

    def message
      default_options.merge!(text: notification.to_s)
    end

    def default_options
      {
        channel: slack_channel,
        as_user: false,
      }
    end

    def slack_channel
      notification.prop.organisation.slack_channel || AppConfig.slack.default_channel
    end
  end
end
