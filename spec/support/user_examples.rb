require 'spec_helper'

shared_examples 'User' do
  let(:agents) { create_list(:agent, 2) }
  let(:operators) { create_list(:operator, 2) }

  describe 'via relations' do
    it { is_expected.to have_many(:contactships).inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:contacts).through(:contactships) }

    context 'should return contacts bidirectional' do
      before do
        agents[0].contacts << agents[1]
        agents[0].contacts << operators
        agents[1].contacts << operators[1]
      end

      it 'for agent 1' do
        expect(agents[0].contacts).to eq([agents[1], operators[0], operators[1]])
      end

      it 'for agent 2' do
        expect(agents[1].contacts).to eq([agents[0], operators[1]])
      end

      it 'for operator 1' do
        expect(operators[0].contacts).to eq([agents[0]])
      end

      it 'for operator 2' do
        expect(operators[1].contacts).to eq(agents)
      end
    end
  end

  describe 'via validations' do
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to allow_value('email@addresse.foo').for(:email) }

    it { is_expected.to_not allow_value('foo').for(:email) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:surname) }
  end

  describe 'DB columns' do
    it 'should have all columns' do
      columns = %w[id name surname email type created_at updated_at]
      expect(described_class.column_names).to include(*columns)
    end
  end
end
