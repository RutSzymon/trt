require 'rails_helper'

RSpec.describe Operator, type: :model do
  subject { build(:operator) }

  it_should_behave_like 'User'
end
