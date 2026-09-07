class PagesController < ApplicationController
  def home
  end

  def about
  end

  def services
    @services = Service.order(:standard_price, :name)
  end

  def workshop
  end
  
end
