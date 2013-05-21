class AccountApplication < ActiveRecord::Base
  attr_protected :created_at, :updated_at

  belongs_to :account
  belongs_to :application

  validates :account, presence: true
  validates :application, presence: true
end
