module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    @current_user = nil
    session.delete(:user_id)
  end

  def current_user
    return if session[:user_id].nil?

    @current_user ||= User.find_by(id: session[:user_id])
  end
end
