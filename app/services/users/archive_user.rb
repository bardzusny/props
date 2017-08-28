module Users
  class ArchiveUser
    pattr_initialize [:user!]

    def call
      user.archived_at = Time.current
      user.save!
      remove_mail_subscription!
    end

    private

    def remove_mail_subscription!
      repository = MailSubscriptionsRepository.new
      subscription = repository.find_for_user(user)
      subscription.update_column(:active, false) if subscription.present?
    end
  end
end
