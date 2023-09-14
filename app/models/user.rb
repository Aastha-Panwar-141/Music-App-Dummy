class User < ApplicationRecord
  self.inheritance_column= :type

  require "securerandom" #an interface to secure random number generators
  has_secure_password #used to encrypt and authenticate passwords using BCrypt . It assumes the model has a column named password_digest
  validates :email, presence: true, uniqueness: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true,
  length: { minimum: 6 },
  if: -> { new_record? || !password.nil? }
end
  