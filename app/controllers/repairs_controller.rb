class RepairsController < ApplicationController
  def index
    @repairs = Repair.includes(bike: :customer).by_promised_date
  end

  def show
    @repair = Repair.includes(
      { bike: :customer },
      :intake_by_staff,
      :assigned_mechanic,
      { repair_items: :service }
    ).find(params[:id])
  end
end
