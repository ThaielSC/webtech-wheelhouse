class ServicesController < ApplicationController
  def index
    @services = Service.by_name
  end

  def show
    @service = Service.includes(repair_items: { repair: :bike }).find(params[:id])
  end
end
