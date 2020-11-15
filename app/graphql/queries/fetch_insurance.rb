module Queries
  class FetchInsurance < Queries::BaseQuery
    type Types::InsuranceType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Insurance.find(id)
    rescue ActiveRecord::RecordNotFound => _e
      GraphQL::ExecutionError.new('Insurance does not exist.')
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
        " #{e.record.errors.full_messages.join(', ')}")
    end

    def authorized?(id:)
      insurance = Insurance.find(id)
      return true if context[:current_ability].can?(:read, insurance)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
