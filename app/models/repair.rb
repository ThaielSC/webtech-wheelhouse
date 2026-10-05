class Repair < ApplicationRecord
  INTAKE_PHOTO_TYPES = %w[image/jpeg image/png].freeze
  INTAKE_PHOTO_SIZE_LIMIT = 10.megabytes

  has_many_attached :intake_photos do |photo|
    photo.variant :thumbnail, resize_to_fill: [ 96, 72 ], format: :jpeg, saver: { quality: 70, strip: true }
    photo.variant :detail, resize_to_limit: [ 960, 720 ], format: :jpeg, saver: { quality: 80, strip: true }
  end
  has_rich_text :diagnosis

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

  validate :acceptable_intake_photos
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
    repair_items.to_a.sum(&:charged_price)
  end

  private

  def acceptable_intake_photos
    intake_photos.each do |photo|
      unless INTAKE_PHOTO_TYPES.include?(photo.blob.content_type)
        errors.add(:intake_photos, "#{photo.blob.filename}: only JPEG and PNG images are accepted")
      end

      if photo.blob.byte_size > INTAKE_PHOTO_SIZE_LIMIT
        errors.add(:intake_photos, "#{photo.blob.filename}: must be 10 MB or smaller")
      end
    end
  end

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
