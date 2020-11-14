module UsersQuery
  extend self

  def contacts(user_id:, scope: false)
    query = relation.joins(sql(scope: scope)).where.not(id: user_id)

    query.where(contactships: { user_id: user_id })
         .or(query.where(contactships: { contact_id: user_id }))
  end

  private

  def relation
    @relation ||= User.all
  end

  def sql(scope: false)
    if scope
      <<~SQL
        OR users.id = contactships.user_id
      SQL
    else
      <<~SQL
        INNER JOIN contactships
          ON users.id = contactships.contact_id
          OR users.id = contactships.user_id
      SQL
    end
  end
end
