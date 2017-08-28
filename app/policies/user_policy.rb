class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      UsersRepository.new.for_organisation(membership.organisation).all
    end
  end

  def show?
    record.organisations.where(id: membership.organisation).exists?
  end
end
