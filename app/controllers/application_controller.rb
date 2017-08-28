class ApplicationController < ActionController::Base
  include SessionHelpers

  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?
  helper_method :current_organisation

  private

  def user_signed_in?
    return true if current_membership
  end

  def correct_user?
    @user = User.find(params[:id])
    redirect_to root_url, alert: 'Access denied.' if current_user != @user
  end

  def authenticate_user!
    return if current_membership.present?
    redirect_to root_url, alert: 'You need to sign in for access to this page.'
  end

  def check_domain!
    return if AppConfig.single_domain_mode.present?
    current = Utils::UrlWithBaseDomain.new(request.url, AppConfig.app_domain)

    if user_signed_in?
      organisation_name = current_organisation.name.parameterize
      if current.subdomain != organisation_name
        redirect_to app_url(host: "#{organisation_name}.#{AppConfig.app_domain}")
      end
    elsif current.subdomain
      current.remove_subdomain
      redirect_to current.to_s
    end
  end
end
