class User < ApplicationRecord
  self.inheritance_column= :type

  require "securerandom" #an interface to secure random number generators
  has_secure_password #used to encrypt and authenticate passwords using BCrypt . It assumes the model has a column named password_digest
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create,
  length: { minimum: 6 }
  validates :user_type, presence: true, inclusion: { in: ['Listener', 'Artist'] }
  has_many :playlists, dependent: :destroy
  has_many :recentyly_playeds

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def update_new_email!(email)
    self.unconfirmed_email = email
    self.generate_confirmation_instructions
    save
  end
  
  def self.email_used?(email)
    existing_user = find_by("email = ?", email)
  
    if existing_user.present?
      return true
    else
      waiting_for_confirmation = find_by("unconfirmed_email = ?", email)
      return waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_token_valid?
    end
  end

  def update_new_email!
    self.email = self.unconfirmed_email
    self.unconfirmed_email = nil
    self.mark_as_confirmed!
  end
  
  
  private
  
  def generate_token
    SecureRandom.hex(10)
  end
  
end
  