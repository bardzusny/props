class UserPropsRepository
  attr_accessor :user, :organisation

  def initialize(user, organisation)
    self.user = user
    self.organisation = organisation
  end

  def given
    Prop.where(propser_id: user.id, organisation_id: organisation.id)
  end

  def received
    user.props.where(organisation_id: organisation.id)
  end
end
