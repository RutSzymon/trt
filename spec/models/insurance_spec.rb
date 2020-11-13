require 'rails_helper'

RSpec.describe Insurance, type: :model do
  subject { build(:insurance) }

  describe 'via enums' do
    it { should define_enum_for(:kind).with_values(Insurance::KINDS) }
  end

  describe 'via relations' do
  end

  describe 'via validations' do
    it { is_expected.to validate_presence_of(:agency_name) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:period) }

    it { is_expected.to validate_presence_of(:total_cost) }
  end

  describe 'DB columns' do
    it 'should have all columns' do
      columns = %w[id name agency_name kind total_cost period created_at updated_at]
      expect(Insurance.column_names).to include(*columns)
    end
  end
end
