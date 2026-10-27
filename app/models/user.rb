class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :staff_member, optional: true
  has_many :repairs, dependent: :nullify

  enum :role, { owner: "owner", mechanic: "mechanic", counter: "counter" }, default: :mechanic

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false },
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :staff_member_id, uniqueness: true, allow_nil: true
  validates :password, length: { minimum: 10, message: "must be at least 10 characters long" }, allow_nil: true

  def display_name
    staff_member&.name.presence || email_address
  end
end
