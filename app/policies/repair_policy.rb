class RepairPolicy < ApplicationPolicy
  def index? = user.present?
  def show? = user.present? && (user.owner? || user.counter? || own?)
  def new? = user.present? && (user.owner? || user.counter?)
  def create? = new?
  def edit? = user.present? && (user.owner? || (!record.completed? && (user.counter? || own?)))
  def update? = edit?
  def destroy_photo? = edit?
  def destroy? = user&.owner? || false

  def permitted_attributes
    return [ :status, :diagnosis, { intake_photos: [] } ] if user.mechanic?

    [ :bike_id, :assigned_mechanic_id, :status, :promised_on, :approved_by_customer,
      :completed_at, :picked_up_at, :diagnosis,
      { intake_photos: [], repair_items_attributes: [ [ :id, :service_id, :charged_price, :notes, :_destroy ] ] } ]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user
      return scope.all if user.owner? || user.counter?
      return scope.none unless user.mechanic? && user.staff_member_id

      scope.where(assigned_mechanic_id: user.staff_member_id)
    end
  end

  private

  def own? = user.mechanic? && user.staff_member_id.present? && record.assigned_mechanic_id == user.staff_member_id
end
