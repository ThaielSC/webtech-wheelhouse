module Api
  module V1
    class ServicesController < BaseController
      skip_before_action :authenticate_token, only: [ :index, :show ]

      def index
        services = Service.by_name.preload(:repair_items)
        render json: services.map { |service| service_document(service) }
      end

      def show
        service = Service.preload(:repair_items).find(params[:id])
        render json: service_document(service)
      end

      def create
        service = Service.new(service_params)
        if service.save
          render json: service_document(service), status: :created, location: api_v1_service_url(service)
        else
          render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def service_params
        attributes = params.expect(service: [ :name, :description, :standard_price ])
        raise ActionController::BadRequest, "Service attributes are required" if attributes.empty?
        attributes
      end

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          standard_price: price(service.standard_price),
          repairs_count: service.repair_items.map(&:repair_id).uniq.size
        }
      end
    end
  end
end
