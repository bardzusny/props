class PropsRepository
  delegate :find, :find_by_slack_ts, to: :all

  def all
    Prop.includes(:users, :propser)
  end

  def count_per_user(organisation, created_at = nil)
    query = kudos_in_organisation(organisation)
    query = query.where(created_at: created_at) if created_at.present?
    query.joins(:prop_receivers).joins(:users).group('users.id').count
  end

  def count_per_time_range(organisation, interval, created_at = nil)
    query = kudos_in_organisation(organisation)
    query = query.where(created_at: created_at) if created_at.present?
    query.group("date_trunc('#{interval}', props.created_at AT TIME ZONE 'MST')").count
  end

  def users_with_kudos_date(organisation, created_at)
    kudos_in_organisation(organisation)
      .where(created_at: created_at).joins(:prop_receivers)
      .group('prop_receivers.id, props.created_at, props.id')
      .order("prop_receivers.user_id, date_trunc('day', created_at)")
      .pluck("prop_receivers.user_id, date_trunc('day', created_at)")
  end

  def oldest_kudos_date(organisation)
    @oldest_kudos_date ||= Hash.new do |h, key|
      h[key] = kudos_in_organisation(key).oldest_first.first&.created_at
    end
    @oldest_kudos_date[organisation]
  end

  def any_kudos?(organisation)
    @any_kudos ||= Hash.new do |h, key|
      h[key] = kudos_in_organisation(key).exists?
    end
    @any_kudos[organisation]
  end

  def add(attributes)
    user_ids = attributes.delete(:user_ids) || ''
    user_ids = clean_ids user_ids
    prop = Prop.new attributes
    add_prop_receivers prop, user_ids
    prop.save
    prop
  end

  def search(attributes)
    PropSearch.new attributes
  end

  private

  def clean_ids(ids_as_text)
    ids = ids_as_text.split(',')
    Array(ids).map(&:to_i) - [0]
  end

  def add_prop_receivers(prop, user_ids)
    user_ids.each do |user_id|
      prop.prop_receivers.build(user_id: user_id)
    end
  end

  def kudos_in_organisation(organisation)
    @kudos_in_organisation ||= Hash.new do |h, key|
      h[key] = key.props
    end
    @kudos_in_organisation[organisation]
  end
end
