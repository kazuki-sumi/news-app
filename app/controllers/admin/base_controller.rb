class Admin::BaseController < ApplicationController
  include SessionsHelper
  before_action :authorize_admin_user
  layout "admin"

  if Rails.env.production?
    rescue_from Exception, with: :render_500
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(e = nil)
    logger.error "Rendering 404 with exception: #{e.class.name} (#{e.message})" if e
    render file: Rails.root.join("public/errors/admin/404.html"), status: :not_found, layout: false, content_type: 'text/html', formats: [:html]
  end

  def render_500(e = nil)
    if e
      logger.error "Rendering 500 with exception: #{e.class.name} (#{e.message})"
      logger.error e.backtrace.join("\n")
    end
    render file: Rails.root.join("public/errors/admin/500.html"), status: :internal_server_error, layout: false, content_type: 'text/html', formats: [:html]
  end

  private

  def authorize_admin_user
    unless current_user&.admin?
      store_location
      redirect_to admin_login_path
    end
  end
end
