class Account < ActiveRecord::Base
  has_secure_password
  attr_protected

  has_many :account_applications, dependent: :destroy
  has_many :applications, through: :account_applications

  validates :name, presence: true
  validates :login, presence: true
end
