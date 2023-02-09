module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= Employee.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end
end
