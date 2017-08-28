class UsersRepository
  ATTRIBUTES_TO_SERIALIZE = %i(id name email uid).freeze
  private_constant :ATTRIBUTES_TO_SERIALIZE

  def all
    User.all.order(:name)
  end

  def all_users_serialized(organisation)
    users_from_organisation(organisation).each_with_object({}) do |user, hash|
      hash[user.id] = user_serialized(user)
    end
  end

  def for_organisation(organisation)
    active.joins(:organisations).where('organisations.id = ?', organisation.id)
  end

  def active
    all.where('archived_at IS NULL')
  end

  def find_by_id(id)
    all.find(id)
  end

  delegate :find_by_email, :find_by_name, to: :all

  def user_from_auth(auth)
    User.create_with_omniauth(auth)
  end

  def user_from_slack(member)
    find_by_member(member) || (report_matching_error(member) && User.create_from_slack(member))
  end

  def user_serialized(user)
    serialized_user = user.serializable_hash(only: ATTRIBUTES_TO_SERIALIZE)
    serialized_user.merge('avatar' => avatar_url(user))
  end

  private

  def users_from_organisation(organisation)
    organisation.users.order(:name)
  end

  def allowed_domains
    AppConfig.extra_domains.to_s.split(',') << AppConfig.domain_name.to_s
  end

  def find_by_member(member)
    find_by_slack_email(member['profile']['email']) || find_by_name(member['profile']['real_name'])
  end

  def find_by_slack_email(email)
    local = email.split('@').first
    emails = [email] | allowed_domains.map { |domain| "#{local}@#{domain.strip}" }

    all.where(email: emails).first
  end

  def report_matching_error(member)
    Rollbar.error("Couldn't match slack member: #{member}")
  end

  def avatar_url(user)
    user.avatar || gravatar_url(user.email)
  end

  def gravatar_url(email)
    Gravatar.new(email).image_url(secure: true)
  end
end
