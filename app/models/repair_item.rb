class RepairItem < ApplicationRecord
  belongs_to :repair
  belongs_to :service

  validates :charged_price, presence: true, numericality: { greater_than: 0, message: "must be a positive amount" }

  scope :by_service_name, -> {
    joins(:service).includes(repair: :bike).includes(:service).order("services.name", :id)
  }
end
