module Mutations
  class DeleteInsurance < Mutations::BaseMutation
    argument :id, ID, required: true

    field :insurance, Types::InsuranceType, null: false

    def resolve(id:)
      insurance = Insurance.find(id)

      begin
        insurance.destroy

        { insurance: insurance }
      rescue ActiveRecord::RecordNotFound => _e
        GraphQL::ExecutionError.new('Insurance does not exist.')
      end
    end

    def authorized?(id:)
      insurance = Insurance.find(id)
      return true if context[:current_ability].can?(:destroy, insurance)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
