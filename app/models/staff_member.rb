class StaffMember < ApplicationRecord
  has_many :intake_repairs, class_name: "Repair", foreign_key: :intake_by_staff_id, dependent: :restrict_with_error, inverse_of: :intake_by_staff
  has_many :assigned_repairs, class_name: "Repair", foreign_key: :assigned_mechanic_id, dependent: :nullify, inverse_of: :assigned_mechanic

  validates :name, presence: true
  validates :role, presence: true

  scope :by_role_and_name, -> { order(:role, :name) }
end
