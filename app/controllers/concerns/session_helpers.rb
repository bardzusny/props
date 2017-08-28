module SessionHelpers
  extend ActiveSupport::Concern

  included do
    def pundit_user
      current_membership
    end

    def current_user
      @current_user ||= current_membership.try(:user)
    end

    def current_organisation
      @current_organisation ||= current_membership.organisation
    end

    def current_membership
      @current_membership ||= session_membership || api_membership
    end

    def api_membership
      EasyTokens::Token.find_by(value: params[:api_key], deactivated_at: nil).try(:owner)
    end

    def session_membership
      Membership.find_by(id: env['rack.session'][:membership_id])
    end
  end
end
