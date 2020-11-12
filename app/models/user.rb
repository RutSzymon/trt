class User < ApplicationRecord
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
