class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :intake_by_staff, class_name: "StaffMember", inverse_of: :intake_repairs
  belongs_to :assigned_mechanic, class_name: "StaffMember", optional: true, inverse_of: :assigned_repairs

  has_many :repair_items, dependent: :destroy
  has_many :services, through: :repair_items, dependent: :restrict_with_error

  enum :status, {
    received: "Received",
    diagnosed: "Diagnosed",
    awaiting_approval: "Awaiting Approval",
    in_progress: "In Progress",
    ready_for_pickup: "Ready for Pickup",
    completed: "Completed",
    declined: "Declined"
  }

  validates :status, presence: true
  validates :promised_on, presence: true

  validate :picked_up_not_before_intake
  validate :handback_and_approval_consistency

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

  def picked_up_not_before_intake
    if picked_up_at.present? && created_at.present? && picked_up_at.to_date < created_at.to_date
      errors.add(:picked_up_at, "cannot be before the day the repair was received")
    end

    if promised_on.present? && created_at.present? && promised_on < created_at.to_date
      errors.add(:promised_on, "cannot be before the day the repair was received")
    end
  end

  def handback_and_approval_consistency
    if picked_up_at.present? && !completed? && !declined?
      errors.add(:picked_up_at, "can only be set when the repair is completed or declined")
    end

    if (in_progress? || ready_for_pickup? || completed?) && approved_by_customer.nil?
      errors.add(:approved_by_customer, "must be recorded before the repair can proceed past approval")
    end
  end
end
