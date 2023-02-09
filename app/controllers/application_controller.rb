class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :user_logged_in?

  private

  def user_logged_in?
    return if logged_in?

    redirect_to login_path
  end
end
