module Api
  module V1
    module Entities
      class UserFull < UserBase
        expose :props_count
        expose :archived

        def archived
          object.archived_at.present?
        end

        private

        def props_count
          {
            given: user_props_repository.given.count,
            received: user_props_repository.received.count,
          }
        end

        def user_props_repository
          UserPropsRepository.new(object, organisation)
        end

        def organisation
          options[:organisation]
        end
      end
    end
  end
end
