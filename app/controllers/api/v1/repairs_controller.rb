module Api
  module V1
    class RepairsController < BaseController
      def index
        repairs = repair_records.by_promised_date
        if params.key?(:state)
          unless Repair.statuses.key?(params[:state])
            raise ActionController::BadRequest, "State must be one of: #{Repair.statuses.keys.join(', ')}"
          end
          repairs = repairs.where(status: params[:state])
        end
        render json: repairs.map { |repair| repair_document(repair) }
      end

      def show
        render json: repair_document(repair_records.find(params[:id]))
      end

      private

      def repair_records
        Repair.preload(bike: :customer, repair_items: :service)
      end

      def repair_document(repair)
        {
          id: repair.id,
          state: repair.status,
          received_on: repair.created_at.to_date,
          promised_on: repair.promised_on,
          handed_back_on: repair.picked_up_at&.to_date,
          bike: { brand: repair.bike.make, model: repair.bike.model, serial_number: repair.bike.serial_number },
          customer: { name: repair.bike.customer.name },
          lines: repair.repair_items.map do |item|
            { service_name: item.service.name, charged_price: price(item.charged_price) }
          end,
          total: price(repair.total),
          overdue: repair.overdue?,
          approved_by_customer: repair.approved_by_customer
        }
      end
    end
  end
end
