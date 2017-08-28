module RankingsHelpers
  def create_kudos_for_user(user, propser, created_at)
    kudos_attrs = {
      user_ids: user.id.to_s,
      propser_id: propser.id,
      organisation: organisation,
      created_at: created_at,
    }
    attrs = attributes_for(:prop).merge(kudos_attrs)
    PropsRepository.new.add(attrs)
  end

  def create_kudos_in_org(organisation, user, propser, created_at)
    kudos_attrs = {
      user_ids: user.id.to_s,
      propser_id: propser.id,
      organisation: organisation,
      created_at: created_at,
    }
    attrs = attributes_for(:prop).merge(kudos_attrs)
    PropsRepository.new.add(attrs)
  end

  def create_kudos_for_users(users, propser, created_at)
    kudos_attrs = {
      user_ids: users.map(&:id).join(','),
      propser_id: propser.id,
      organisation: organisation,
      created_at: created_at,
    }
    attrs = attributes_for(:prop).merge(kudos_attrs)
    PropsRepository.new.add(attrs)
  end
end
