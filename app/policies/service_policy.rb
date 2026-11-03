class ServicePolicy < ApplicationPolicy
  def index? = true
  def show? = true
  def new? = user&.owner? || false
  def create? = new?
  def edit? = new?
  def update? = edit?
  def destroy? = new?

  class Scope < ApplicationPolicy::Scope
    def resolve = scope.all
  end
end
