class Agent < User
  has_many :contracts
  has_many :insurances, through: :contracts
end
