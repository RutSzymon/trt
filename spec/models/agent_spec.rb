require 'rails_helper'

RSpec.describe Agent, type: :model do
  subject { build(:agent) }

  describe 'via relations' do
    it { is_expected.to have_many(:contracts) }
    it { is_expected.to have_many(:insurances).through(:contracts) }
  end

  it_should_behave_like 'User'
end
