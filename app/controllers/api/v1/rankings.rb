module Api
  module V1
    class Rankings < Grape::API
      include Api::V1::Defaults

      helpers do
        include Api::V1::Helpers

        def props_repository
          PropsRepository.new
        end

        def users_repository
          UsersRepository.new
        end

        def time_range
          params[:time_range]
        end

        def arguments_hash
          {
            users_repository: users_repository,
            props_repository: props_repository,
            organisation: current_organisation,
            time_range_string: time_range,
          }
        end
      end

      before do
        require_api_auth!(params[:token])
      end

      resources :rankings do
        desc 'Returns user with the most received kudos'
        get :hero_of_the_week do
          RankingRepository.new(users_repository: users_repository,
                                props_repository: props_repository,
                                organisation: current_organisation,
                                time_range_string: 'weekly').hero_of_the_week
        end

        desc 'Returns users in order of received kudos number'
        params do
          requires :time_range, type: String
        end
        get :top_kudoers do
          RankingRepository.new(arguments_hash).top_kudosers
        end

        desc 'Returns kudos count in required time range'
        params do
          requires :time_range, type: String
        end
        get :team_activity do
          RankingRepository.new(arguments_hash).team_activity
        end

        desc 'Returns users with kudos streak'
        params do
          requires :time_range, type: String
        end
        get :kudos_streak do
          RankingRepository.new(arguments_hash).kudos_streak
        end
      end
    end
  end
end
