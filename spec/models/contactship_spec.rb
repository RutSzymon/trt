require 'rails_helper'

RSpec.describe Contactship, type: :model do
  subject { build(:contactship) }

  describe 'via relations' do
    it { is_expected.to belong_to(:contact).class_name('User') }
    it { is_expected.to belong_to(:user) }
  end
end
