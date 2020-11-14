module ContactshipsQuery
  extend self

  def both_ways(user_id:)
    relation.unscope(where: :user_id)
            .where(user_id: user_id)
            .or(relation.where(contact_id: user_id))
  end

  private

  def relation
    @relation ||= Contactship.all
  end
end
