module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :use_json
      before_action :authenticate_token, except: :not_found

      rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :not_found
      rescue_from ActionController::ParameterMissing, ActionController::BadRequest, ActionDispatch::Http::Parameters::ParseError, with: :bad_request

      def not_found
        render json: { errors: [ "Resource not found" ] }, status: :not_found
      end

      private

      def use_json
        request.format = :json
      end

      def authenticate_token
        expected = Rails.application.credentials.dig(:api, :token)
        authenticated = request.authorization.to_s.start_with?("Bearer ") &&
          authenticate_with_http_token do |token, _options|
            expected.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected)
          end
        return if authenticated

        response.set_header("WWW-Authenticate", 'Bearer realm="Wheelhouse"')
        render json: { errors: [ "A valid Bearer token is required" ] }, status: :unauthorized
      end

      def bad_request(error)
        render json: { errors: [ error.message ] }, status: :bad_request
      end

      def price(amount)
        format("%.2f", amount)
      end
    end
  end
end
