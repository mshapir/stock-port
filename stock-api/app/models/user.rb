class User < ApplicationRecord
  has_secure_password
  validates :password, length: { in: 6..200 }
  validates_confirmation_of :password, allow_nil: true, allow_blank: false
  validates_presence_of :name
  validates :email, uniqueness: true

  has_many :transactions

end
