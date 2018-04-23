class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from Exception, with: :render_500
  def render_500(exception = nil)
    raise unless Rails.env.production?
    logger.error(exception.message) if exception
    render template: '500', status: 500
  end

  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, with: :render_404
  def render_404
    render template: '404', status: 404
  end
end
