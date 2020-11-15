class ContactshipCounter < ApplicationService
  def initialize(contactship)
    @contactship = contactship
    super()
  end

  def call
    @contactship.previous_changes.slice('contact_id', 'user_id').each do |_attr, values|
      values.each { |user_id| update_user_contacts_count(user_id) }
    end
  end

  private

  def update_user_contacts_count(user_id)
    return unless user_id.present?

    user = User.find(user_id)
    user.update_column(:contacts_count, user.contacts.size)
  end
end
