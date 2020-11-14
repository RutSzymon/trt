class User < ApplicationRecord
  has_many :contactships, ->(user) { ContactshipsQuery.both_ways(user_id: user.id) }, inverse_of: :user, dependent: :destroy
  has_many :contacts, ->(user) { UsersQuery.contacts(user_id: user.id, scope: true) }, through: :contactships

  validates :email, presence: true, uniqueness: { case_sensitive: true }, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :name, presence: true
  validates :surname, presence: true
end
