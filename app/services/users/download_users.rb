module Users
  class DownloadUsers
    vattr_initialize [:organisation!]

    def call
      create_or_update_users
    end

    private

    def create_or_update_users
      users_array.each do |user_info|
        next if invalid_user?(user_info)
        user = Users::CreateFromSlackFetch.new(user_info: user_info).call
        organisation.add_user(user) if user.present?
      end
    end

    def users_array
      client.users_list.members
    end

    def client
      Slack::RealTime::Client.new(token: token).web_client
    end

    def token
      organisation.token
    end

    def invalid_user?(user_info)
      bot_user?(user_info) ||
        guest_user?(user_info) ||
        new_archived_user?(user_info)
    end

    def bot_user?(user_info)
      user_info['is_bot'] || user_info['name'].inquiry.slackbot?
    end

    def guest_user?(user_info)
      user_info['profile']['guest_channels'].present? ||
        user_info['is_restricted'] ||
        user_info['is_ultra_restricted']
    end

    def new_archived_user?(user_info)
      User.find_by(uid: user_info['id']).blank? && user_info['deleted']
    end
  end
end
