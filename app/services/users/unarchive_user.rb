module Users
  class UnarchiveUser
    pattr_initialize [:user!]

    def call
      user.archived_at = nil
      user.save!
      restore_mail_subscription!
      user
    end

    private

    def restore_mail_subscription!
      repository = MailSubscriptionsRepository.new
      subscription = repository.find_for_user(user)
      subscription.update_column(:active, true) if subscription.present?
    end
  end
end
