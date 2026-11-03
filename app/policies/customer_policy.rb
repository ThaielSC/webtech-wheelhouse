class CustomerPolicy < ApplicationPolicy
  def index? = user.present? && (user.owner? || user.counter?)
  def show? = index?
  def new? = index?
  def create? = new?
  def edit? = index?
  def update? = edit?
  def destroy? = user&.owner? || false

  class Scope < ApplicationPolicy::Scope
    def resolve = user && (user.owner? || user.counter?) ? scope.all : scope.none
  end
end
