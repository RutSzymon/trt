class Contactship < ApplicationRecord
  belongs_to :contact, class_name: 'User'
  belongs_to :user
end
