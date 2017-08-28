module Api
  module V1
    class Props < Grape::API
      include Api::V1::Defaults

      helpers do
        include Api::V1::Helpers

        def kaminari_params(collection)
          {
            current_page: collection.current_page,
            next_page: collection.next_page,
            prev_page: collection.prev_page,
            total_pages: collection.total_pages,
            total_count: collection.total_count,
          }
        end

        def paginated_result(results, page)
          return { collection: results, meta: {} } if page.nil?

          collection = results.page(page)
          {
            collection: collection,
            meta: kaminari_params(collection),
          }
        end

        def props_params(params)
          params.merge(show_upvote_status_for_user_id: current_user.id)
        end

        def prop_params(params)
          params.merge(propser_id: current_user.id, organisation_id: current_organisation.id)
        end

        def props_repository
          PropsRepository.new
        end

        def upvotes_repository
          UpvotesRepository.new
        end

        def prop
          props_repository.find(params[:prop_id])
        end
      end

      before do
        authenticate_user!
      end

      resources :props do
        desc 'Returns props match search params'
        params do
          optional :user_id, type: Integer
          optional :propser_id, type: Integer
          optional :show_upvote_status_for_user_id, type: Integer
        end
        get do
          search_params = declared(props_params(params)).merge(
            organisation_id: current_organisation.id,
          )
          prop_search = props_repository.search(search_params)
          params[:page] = params[:page] || 1 if params[:propser_id].present?

          results = paginated_result(prop_search.results, params[:page])
          present results[:collection],
                  with: Entities::Props,
                  pagination: results[:meta],
                  current_user: current_user
        end

        desc 'Returns props count'
        get :total do
          current_organisation.props.count
        end

        desc 'Creates a new prop'
        params do
          requires :body, type: String
          requires :user_ids, type: String
        end
        post do
          create_prop = ::Props::Create.new(props_repository, prop_params(declared(params))).call
          if create_prop.success?
            present create_prop.data, with: Entities::Prop, current_user: current_user
          else
            error!({ errors: create_prop.errors }, 422)
          end
        end

        namespace ':prop_id' do
          desc 'Upvotes specific prop'
          params do
            requires :prop_id, type: Integer
          end
          post :upvotes do
            upvote_prop = ::Props::Upvote.new(
              prop: prop,
              user: current_user,
              upvotes_repository: upvotes_repository,
            ).call

            if upvote_prop.success?
              present upvote_prop.data, with: Entities::Prop, current_user: current_user
            else
              error!({ errors: upvote_prop.errors }, 422)
            end
          end

          desc 'Undoes upvote on specific prop'
          params do
            requires :prop_id, type: Integer
          end
          delete :undo_upvotes do
            undo_upvote_prop = ::Props::UndoUpvote.new(
              prop: prop,
              user: current_user,
              upvotes_repository: upvotes_repository,
            ).call

            if undo_upvote_prop.success?
              present undo_upvote_prop.data, with: Entities::Prop, current_user: current_user
            else
              error!({ errors: undo_upvote_prop.errors }, 422)
            end
          end
        end
      end
    end
  end
end
