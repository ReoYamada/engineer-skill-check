class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :user_logged_in?
  before_action :new_message

  private

  def user_logged_in?
    return if logged_in?

    redirect_to login_path
  end

  def new_message
    return unless logged_in? && (EmployeeArticle.where(employee_id: session[:user_id]).count < Article.count)

    flash.now[:new_message] = '新着のお知らせがあります'
  end
end
