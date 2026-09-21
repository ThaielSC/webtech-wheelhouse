class Service < ApplicationRecord
  has_many :repair_items, dependent: :restrict_with_error
  has_many :repairs, through: :repair_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :standard_price, presence: true, numericality: { greater_than: 0, message: "must be a positive amount" }

  before_validation :normalize_name

  scope :by_name, -> { order(:name) }

  private

  def normalize_name
    self.name = name.strip if name.present?
  end
end
