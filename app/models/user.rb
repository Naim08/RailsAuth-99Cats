class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_validation :ensure_session_token
  attr_reader :password

  has_many :cats, dependent: :destroy, foreign_key: :owner_id, inverse_of: :owner
  has_many :rental_requests, dependent: :destroy, foreign_key: :requester_id, inverse_of: :requester
  def self.generate_unique_session_token
    token = SecureRandom.urlsafe_base64
    token = SecureRandom.urlsafe_base64 while User.exists?(session_token: token)
    token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username:)
    return nil unless user

    user.is_password?(password) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= User.generate_unique_session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = User.generate_unique_session_token
    save!
    self.session_token
  end
end
