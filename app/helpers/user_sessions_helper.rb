module UserSessionsHelper
  def user_log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user&.authenticated?(:remember, cookies[:remember_token])
        user_log_in(user)
        user
      end
    end
  end

  def user_logged_in?
    !current_user.nil?
  end

  def user_remember(user)
    user.remember
    cookies.signed[:user_id] = { value: user.id, expires: 1.day.from_now }
    cookies.signed[:remember_token] = { value: user.remember_token, expires: 1.day.from_now }
  end

  def user_log_out
    user_forget(current_user)
    session.delete(:user_id)
    # @current_user = nil
  end

  def user_forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # TODO 移管検討
  # 記憶したURLにリダイレクト
  def redirect_back_or(default)
    redirect_to session[:forwarding_url] || default
    session.delete(:forwarding_url)
  end

  # TODO 移管検討
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
