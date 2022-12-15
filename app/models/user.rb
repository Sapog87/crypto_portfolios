class User < ApplicationRecord
  has_one :portfolio
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  has_secure_password
end
