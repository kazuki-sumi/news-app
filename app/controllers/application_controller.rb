class ApplicationController < ActionController::Base
  helper_method :logged_in?

  if Rails.env.production?
    rescue_from Exception, with: :render_500
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.class.name} (#{exception.message})" if exception
    render file: Rails.root.join("public/errors/404.html"),
      status: :not_found, layout: false, content_type: 'text/html', formats: [:html]
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.class.name} (#{exception.message})"
      logger.error exception.backtrace.inspect
    end
    render file: Rails.root.join("public/errors/500.html"),
      status: :internal_server_error, layout: false, content_type: 'text/html', formats: [:html]
  end

  protected

  def log_in(user)
    binding.pry
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = user.find_by(id: user_id)
      if user && user&.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.remember
    cookies.signed[:user_id] = { value: user.id, expires: 1.day.from_now }
    cookies.signed[:remember_token] = { value: user.remember_token, expires: 1.day.from_now }
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    # @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 記憶したURLにリダイレクト
  def redirect_back_or(default)
    redirect_to session[:forwarding_url] || default
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
