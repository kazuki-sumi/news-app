class Admin::BaseController < ApplicationController
  # include Admin::SessionsHelper
  before_action :authorize_operator
  helper_method :logged_in?, :current_operator
  layout "admin"

  if Rails.env.production?
    rescue_from Exception, with: :render_500
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.class.name} (#{exception.message})" if exception
    render file: Rails.root.join("public/errors/admin/404.html"),
      status: :not_found, layout: false, content_type: 'text/html', formats: [:html]
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.class.name} (#{exception.message})"
      logger.error exception.backtrace.join("\n")
    end
    render file: Rails.root.join("public/errors/admin/500.html"),
      status: :internal_server_error, layout: false, content_type: 'text/html', formats: [:html]
  end

  protected

  def log_in(operator)
    session[:operator_id] = operator.id
  end

  def current_operator
    if (operator_id = session[:operator_id])
      Operator.find_by(id: operator_id)
    elsif (operator_id = cookies.signed[:operator_id])
      operator = Operator.find_by(id: operator_id)
      if operator && operator&.authenticated?(:remember, cookies[:remember_token])
        log_in(operator)
        operator
      end
    end
  end

  def logged_in?
    !current_operator.nil?
  end

  def remember(operator)
    operator.remember
    cookies.signed[:operator_id] = { value: operator.id, expires: 1.day.from_now }
    cookies.signed[:remember_token] = { value: operator.remember_token, expires: 1.day.from_now }
  end

  def log_out
    forget(current_operator)
    session.delete(:operator_id)
    # @current_operator = nil
  end

  def forget(operator)
    operator.forget
    cookies.delete(:operator_id)
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

  private

  def authorize_operator
    unless current_operator&.admin?
      store_location
      redirect_to admin_login_path
    end
  end
end
