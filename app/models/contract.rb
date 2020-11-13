class Contract < ApplicationRecord
  belongs_to :agent
  belongs_to :client
  belongs_to :insurance
end
