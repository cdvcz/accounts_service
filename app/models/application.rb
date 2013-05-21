class Application < ActiveRecord::Base
  attr_protected :created_at, :updated_at

  has_many :account_applications, dependent: :destroy
  validates :name, presence: true
end
