class SessionsController < ApplicationController
  before_action :reset_session, only: %i(create destroy)

  def new
    redirect_to '/auth/slack'
  end

  def create
    membership = Users::SignIn.new(auth: request.env['omniauth.auth']).call
    session[:membership_id] = membership.id
    redirect_to app_url, notice: 'Signed in!'
  end

  def destroy
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to root_url
  end
end
