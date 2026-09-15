class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :intake_by_staff, class_name: "StaffMember"
  belongs_to :assigned_mechanic, class_name: "StaffMember", optional: true

  has_many :repair_items
end
