class HomeController < ApplicationController
  before_filter :authorized_api_client

  def index
  end
end
