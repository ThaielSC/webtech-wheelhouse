class StaffMemberPolicy < ServicePolicy
  def index? = user.present?
  def show? = index?

  class Scope < ApplicationPolicy::Scope
    def resolve = user ? scope.all : scope.none
  end
end
