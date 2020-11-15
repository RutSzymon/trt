module Mutations
  class UpdateInsurance < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :params, Types::Input::InsuranceInputType, required: true

    field :insurance, Types::InsuranceType, null: false

    def resolve(id:, params:)
      insurance = Insurance.find(id)
      insurance_params = Hash params

      begin
        insurance.update!(insurance_params)

        { insurance: insurance }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Insurance does not exist.')
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def authorized?(id:, params:)
      insurance = Insurance.find(id)
      return true if context[:current_ability].can?(:update, insurance)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
