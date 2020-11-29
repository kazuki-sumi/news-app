class ApplicationController < ActionController::Base
  include UserSessionsHelper

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
end
