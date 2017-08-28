class PropSearch < Searchlight::Search
  def base_query
    Prop.with_includes.ordered
  end

  def search_user_id
    query.where(prop_receivers: { user_id: user_id })
  end

  def search_organisation_id
    query.where(organisation_id: organisation_id)
  end

  def search_after
    query.where('props.created_at >= ?', after)
  end

  def search_show_upvote_status_for_user_id
    query
      .select("props.*, (SELECT 1 FROM upvotes WHERE
              upvotes.user_id = #{show_upvote_status_for_user_id}
              AND upvotes.prop_id = props.id LIMIT 1)
              AS user_has_upvoted")
  end

  def search_propser_id
    query.where propser_id: propser_id
  end
end
