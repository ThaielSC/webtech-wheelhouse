class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  allow_browser versions: :modern
  stale_when_importmap_changes

  after_action :verify_authorization_used, if: -> { Rails.env.development? }
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  private

  def pundit_user = Current.user

  def verify_authorization_used
    verify_authorized
    verify_policy_scoped if action_name == "index"
  end

  def forbidden
    render "errors/forbidden", status: :forbidden, formats: :html
  end
end
