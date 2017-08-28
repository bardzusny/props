module Props
  class UndoUpvote
    pattr_initialize %i(prop! user! upvotes_repository!)

    def call
      upvote = upvotes_repository.remove(prop, user)
      if upvote.nil?
        Response::Error.new(errors: I18n.t('props.errors.no_upvote'))
      else
        Response::Success.new(data: prop.reload)
      end
    end
  end
end
