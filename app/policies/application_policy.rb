class ApplicationPolicy
  attr_reader :membership, :record

  def initialize(membership, record)
    @membership = membership
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(membership, record.class)
  end

  class Scope
    attr_reader :membership, :scope

    def initialize(membership, scope)
      @membership = membership
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
