class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user, @record = user, record
  end

  def index? = false
  def show? = false
  def new? = false
  def create? = false
  def edit? = false
  def update? = false
  def destroy? = false

  class Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user, @scope = user, scope
    end

    def resolve = scope.none
  end
end
