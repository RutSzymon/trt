module Mutations
  class AddInsurance < Mutations::BaseAddMutation
    argument :params, Types::Input::InsuranceInputType, required: true

    field :insurance, Types::InsuranceType, null: false

    def resolve(params:)
      insurance_params = Hash params

      begin
        insurance = Insurance.create!(insurance_params)

        { insurance: insurance }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end
