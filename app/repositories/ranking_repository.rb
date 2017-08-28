class RankingRepository
  pattr_initialize %i(users_repository! props_repository! organisation! time_range_string!)

  def hero_of_the_week
    return no_kudos_yet unless organisation_has_kudos?
    Rankings::TopKudosers.new(arguments_hash).hero_of_the_week
  end

  def top_kudosers
    return no_kudos_yet unless organisation_has_kudos?
    Rankings::TopKudosers.new(arguments_hash).top_kudosers
  end

  def team_activity
    return no_kudos_yet unless organisation_has_kudos?
    props_repository.count_per_time_range(organisation, time_interval, time_range)
  end

  def kudos_streak
    return no_kudos_yet unless organisation_has_kudos?
    Rankings::KudosStreak.new(arguments_hash).kudos_streak
  end

  private

  def arguments_hash
    {
      users_repository: users_repository,
      props_repository: props_repository,
      organisation: organisation,
      time_range: time_range,
    }
  end

  def no_kudos_yet
    { text: I18n.t('props.messages.no_kudos_yet') }
  end

  def organisation_has_kudos?
    props_repository.any_kudos?(organisation)
  end

  def time_range
    time_range_processor.time_range
  end

  def time_interval
    time_range_processor.time_interval
  end

  def time_range_processor
    @time_range_processor ||= Rankings::ProcessTimeRange.new(processor_arguments_hash)
  end

  def processor_arguments_hash
    {
      time_range_string: time_range_string,
      props_repository: props_repository,
      organisation: organisation,
    }
  end
end
