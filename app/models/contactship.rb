class Contactship < ApplicationRecord
  belongs_to :contact, class_name: 'User'
  belongs_to :user

  after_save :update_counters
  after_destroy :update_counters

  private

  def update_counters
    ContactshipCounter.call(self)
  end
end
