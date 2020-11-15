class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Operator)
      can :manage, :all
    else
      can %i[read create update], [Client, Contract]
      can [:update], [Agent], id: user.id
      can [:read], [Operator], id: user.contact_ids
    end
  end
end
