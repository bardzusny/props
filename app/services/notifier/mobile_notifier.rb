class Notifier
  class MobileNotifier < Base
    def initialize(notification)
      Dotenv.load
      OneSignal::OneSignal.api_key = ENV['ONESIGNAL_API_KEY']
      OneSignal::OneSignal.user_auth_key = ENV['ONESIGNAL_USER_AUTH_KEY']
      @notification = notification
    end

    attr_reader :notification

    def notify
      app_id = ENV['APP_ID']
      player_ids = notification.prop.users.pluck(:pid)
      params = {
        app_id: app_id,
        include_player_ids: player_ids,
        contents: {
          en: notification.mobile_body,
        },
      }

      send_notification(params)
    end

    def send_notification(params)
      response = OneSignal::Notification.create(params: params)
      response['status']
    rescue OneSignal::OneSignalError => e
      e.http_status
    end
  end
end