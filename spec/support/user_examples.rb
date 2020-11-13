require "spec_helper"

shared_examples "User" do
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
      columns = %w(id name surname email type created_at updated_at)
      expect(described_class.column_names).to include(*columns)
    end
  end
end
