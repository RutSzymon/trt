module Mutations
  class BaseAddMutation < Mutations::BaseMutation
    def ready?(**args)
      if !context[:current_ability].can?(:create, Client)
        raise GraphQL::ExecutionError, "Access denied"
      else
        true
      end
    end
  end
end
