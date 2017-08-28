class AuthenticatedController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_domain!

  def main_app; end
end
