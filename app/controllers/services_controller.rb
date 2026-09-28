class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy]

  def index
    @services = Service.by_name
  end

  def show
    @repair_items = @service.repair_items.includes(repair: :bike).order(:id)
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to @service, notice: "Service #{@service.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "Service #{@service.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path, notice: "Service #{@service.name} was deleted.", status: :see_other
    else
      redirect_to @service, status: :see_other,
        alert: "Service #{@service.name} could not be deleted: #{@service.errors.full_messages.to_sentence}."
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.expect(service: %i[name description standard_price])
  end
end
