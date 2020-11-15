require 'rails_helper'

RSpec.describe ContactshipCounter, type: :model do
  describe '#call' do
    let(:agent) { create(:agent) }
    let(:operator) { create(:operator) }
    let(:contactship) { build(:contactship, user: agent, contact: operator) }

    it 'should increment contacts_counts after create' do
      expect { contactship.save! }
        .to(change { agent.reload.contacts_count }.from(0).to(1)
        .and(change { operator.reload.contacts_count }.from(0).to(1)))
    end

    it 'should decrement contacts_counts after destroy' do
      contactship.save!
      expect { contactship.destroy! }
        .to(change { agent.reload.contacts_count }.from(1).to(0)
        .and(change { operator.reload.contacts_count }.from(1).to(0)))
    end

    it 'should update contacts_counts after update' do
      new_contact = create(:agent)
      contactship.save!
      expect { contactship.update!(contact: new_contact) }
        .to(change { operator.reload.contacts_count }.from(1).to(0)
        .and(change { new_contact.reload.contacts_count }.from(0).to(1)
        .and(not_change { agent.reload.contacts_count })))
    end
  end
end
