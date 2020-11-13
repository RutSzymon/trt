require 'rails_helper'

RSpec.describe Contract, type: :model do
  subject { build(:contract) }

  describe 'via relations' do
    it { is_expected.to belong_to(:agent) }

    it { is_expected.to belong_to(:client) }

    it { is_expected.to belong_to(:insurance) }
  end

  describe 'DB columns' do
    it 'should have all columns' do
      columns = %w[id client_id agent_id insurance_id created_at updated_at]
      expect(Contract.column_names).to include(*columns)
    end
  end
end
