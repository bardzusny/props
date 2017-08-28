module Props
  class Upvote
    pattr_initialize %i(prop! user! upvotes_repository!)

    def call
      upvote = upvotes_repository.add(prop, user)
      if upvote.persisted?
        Response::Success.new(data: prop.reload)
      else
        Response::Error.new(errors: upvote.errors)
      end
    end
  end
end
