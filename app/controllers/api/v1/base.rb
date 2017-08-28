module Api
  module V1
    class Base < Grape::API
      rescue_from Pundit::NotAuthorizedError do
        error!('Permission denied', 403)
      end
      mount Api::V1::Props
      mount Api::V1::Users
      mount Api::V1::Rankings
      mount Api::V1::Sessions
      mount Api::V1::SlackCommands

      add_swagger_documentation base_path: '/api/v1',
                                api_version: 'v1',
                                hide_documentation_path: true
    end
  end
end
