class PagesController < ApplicationController
  skip_after_action :verify_authorization_used
  def home
  end

  def about
  end

  def workshop
  end
end
