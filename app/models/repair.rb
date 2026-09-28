class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :intake_by_staff, class_name: "StaffMember", inverse_of: :intake_repairs
  belongs_to :assigned_mechanic, class_name: "StaffMember", optional: true, inverse_of: :assigned_repairs

  has_many :repair_items, dependent: :destroy, inverse_of: :repair
  accepts_nested_attributes_for :repair_items, allow_destroy: true,
    reject_if: ->(attributes) { attributes["service_id"].blank? }
  has_many :services, through: :repair_items, dependent: :restrict_with_error

  enum :status, {
    received: "Received",
    diagnosed: "Diagnosed",
    awaiting_approval: "Awaiting Approval",
    in_progress: "In Progress",
    ready_for_pickup: "Ready for Pickup",
    completed: "Completed",
    declined: "Declined"
  }, validate: true

  validates :status, presence: true
  validates :promised_on, presence: true

  validate :dates_not_before_intake
  validate :pickup_requires_finished_status
  validate :approval_decision_required_before_work

  scope :not_handed_back, -> { where(picked_up_at: nil) }
  scope :overdue, -> { not_handed_back.where("promised_on < ?", Date.current) }
  scope :by_promised_date, -> { order(:promised_on, :created_at) }
  scope :newest_first, -> { order(created_at: :desc) }

  def status_label
    Repair.statuses[status]
  end

  def overdue?
    picked_up_at.nil? && promised_on.present? && promised_on < Date.current
  end

  def total
    repair_items.sum(:charged_price)
  end

  private

  def dates_not_before_intake
    intake_date = created_at&.to_date || Date.current

    if picked_up_at.present? && picked_up_at.to_date < intake_date
      errors.add(:picked_up_at, "cannot be before the day the repair was received")
    end

    if promised_on.present? && promised_on < intake_date
      errors.add(:promised_on, "cannot be before the day the repair was received")
    end
  end

  def pickup_requires_finished_status
    if picked_up_at.present? && !completed? && !declined?
      errors.add(:picked_up_at, "can only be set when the repair is completed or declined")
    end
  end

  def approval_decision_required_before_work
    if (in_progress? || ready_for_pickup? || completed?) && approved_by_customer.nil?
      errors.add(:approved_by_customer, "must be recorded before the repair can proceed past approval")
    end
  end
end
