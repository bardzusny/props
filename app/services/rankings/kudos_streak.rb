module Rankings
  class KudosStreak
    pattr_initialize %i(users_repository! props_repository! organisation! time_range!)

    def kudos_streak
      kudos_streak_within
    end

    private

    def kudos_streak_within
      users_with_kudos_date = props_repository.users_with_kudos_date(organisation, time_range)
      splitted_array = split_on_users(users_with_kudos_date)
      sort_on_streak_count serialize_streak(splitted_array)
    end

    def split_on_users(users_with_kudos_date)
      users_with_kudos_date.chunk_while do |first_pair, second_pair|
        first_user = first_pair.first
        second_user = second_pair.first
        first_user == second_user
      end.to_a
    end

    def sort_on_streak_count(users_streak)
      users_streak.sort { |first_hash, second_hash| second_hash[:streak] <=> first_hash[:streak] }
    end

    def serialize_streak(splitted_array)
      splitted_array.each_with_object([]) do |elem, arr|
        arr.push(
          streak: count_user_streak(elem),
          user: serialized_users[elem.first.first],
        )
      end
    end

    def count_user_streak(one_user_and_kudos_dates)
      one_user_and_kudos_dates.uniq.chunk_while do |first_pair, second_pair|
        first_date = first_pair.second
        next_date = second_pair.second
        first_date + 1.day == next_date
      end.map(&:count).max
    end

    def serialized_users
      @serialized_users ||= users_repository.all_users_serialized(organisation)
    end
  end
end
