class Client < ApplicationRecord
  has_many :contracts
  has_many :insurances, through: :contracts

  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :name, presence: true
  validates :surname, presence: true
end
