class HomeController < ApplicationController
  before_filter :move_to_app_if_user
  before_filter :check_domain!

  def index; end

  private

  def move_to_app_if_user
    redirect_to app_path if current_user.present?
  end
end
