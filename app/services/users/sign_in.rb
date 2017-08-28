module Users
  class SignIn
    def initialize(auth:,
                   users_repository: UsersRepository.new,
                   organisations_repository: OrganisationsRepository.new)
      @auth = auth
      @users_repository = users_repository
      @organisations_repository = organisations_repository
    end

    def call
      user = @users_repository.user_from_auth(@auth)
      organisation = @organisations_repository.from_auth(@auth)
      organisation.add_user(user)
      Membership.find_by(user: user, organisation: organisation)
    end
  end
end
