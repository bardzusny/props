module Users
  class CreateFromOmniauth
    pattr_initialize [:auth!]

    def call
      return update_with_slack_fetch if slack_user.present?
      User.create! omniauth_attrs
    end

    private

    def update_with_slack_fetch
      slack_user.tap { |user| user.update omniauth_attrs }
    end

    def slack_user
      @slack_user ||= user_found_by_uid || user_found_by_email
    end

    def user_found_by_uid
      User.find_by(uid: auth['uid'])
    end

    def user_found_by_email
      User.find_by('email LIKE ?', "#{email_without_domain}%") if email_from_auth.present?
    end

    def email_from_auth
      auth['info']['email']
    end

    def email_without_domain
      email_from_auth.split('@').first
    end

    def omniauth_attrs
      {
        provider: auth['provider'],
        uid: auth['uid'],
        name: name_from_auth,
        email: auth['info']['email'] || '',
        admin: auth['info']['is_admin'] || false,
        avatar: big_avatar_512 || small_avatar_192,
      }
    end

    def name_from_auth
      real_name || auth['info']['name'].presence || ''
    end

    def real_name
      auth.dig('extra', 'user_info', 'user', 'profile', 'real_name')
    end

    def big_avatar_512
      auth.dig('extra', 'user_info', 'user', 'profile', 'image_512')
    end

    def small_avatar_192
      auth['info']['image']
    end
  end
end
