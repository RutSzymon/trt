require 'rails_helper'

RSpec.describe Agent, type: :model do
  subject { build(:agent) }

  it_should_behave_like 'User'
end
