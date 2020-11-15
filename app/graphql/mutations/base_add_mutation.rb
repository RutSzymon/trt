module Mutations
  class BaseAddMutation < Mutations::BaseMutation
    def ready?(**_args)
      return true if context[:current_ability].can?(:create, self.class.to_s.gsub('Mutations::Add', '').constantize)

      raise GraphQL::ExecutionError, 'Access denied'
    end
  end
end
