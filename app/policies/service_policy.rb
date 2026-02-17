class ServicePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user&.admin?

      scope.where(user: user)
    end
  end

  def show?
    owner? || user&.admin?
  end

  def create?
    user.present?
  end

  def update?
    owner? || user&.admin?
  end

  def destroy?
    owner? || user&.admin?
  end

  private

  def owner?
    record.user == user
  end
end
