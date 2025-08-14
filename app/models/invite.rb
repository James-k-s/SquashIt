class Invite < ApplicationRecord
  belongs_to :tournament
  belongs_to :invited_user, class_name: "User", optional: true

  enum status: { pending: "pending", accepted: "accepted", declined: "declined" }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  validates :token, uniqueness: true

  before_create :generate_token
  before_create :set_default_status
  before_create :ensure_token


  def expired?
    expires_at.present? && Time.current > expires_at
  end

  private

  def ensure_token
    self.token ||= SecureRandom.hex(16)
  end

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end

  def set_default_status
    self.status ||= "pending"
  end
end
