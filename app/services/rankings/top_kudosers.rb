module Rankings
  class TopKudosers
    pattr_initialize %i(users_repository! props_repository! organisation! time_range!)

    def hero_of_the_week
      top_kudoser_within
    end

    def top_kudosers
      list_top_kudosers_within
    end

    private

    def top_kudoser_within
      id_with_count = users_with_kudos_count.max_by { |_k, v| v }
      user = User.find(id_with_count.first)
      kudos_count = id_with_count.second
      {
        user: user.name,
        kudos_count: kudos_count,
      }
    end

    def list_top_kudosers_within
      sorted_users.each_with_object(top_kudosers: []) do |arr, hsh|
        hsh[:top_kudosers].push(
          kudos_count: arr[1],
          user: serialized_users[arr[0]],
        )
      end
    end

    def sorted_users
      @sorted_users ||= users_with_kudos_count.sort_by { |_k, v| v }.reverse
    end

    def users_with_kudos_count
      props_repository.count_per_user(organisation, time_range)
    end

    def serialized_users
      @serialized_users ||= users_repository.all_users_serialized(organisation)
    end
  end
end
