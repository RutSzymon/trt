require "rails_helper"

RSpec.describe Client, type: :model do
  subject{ build(:client) }

  describe "via relations" do
  end

  describe "via validations" do
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to allow_value("email@addresse.foo").for(:email) }

    it { is_expected.to_not allow_value("foo").for(:email) }

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:surname) }
  end

  describe "DB columns" do
    it "should have all columns" do
      columns = %w(id name surname email created_at updated_at)
      expect(Client.column_names).to include(*columns)
    end
  end
end
