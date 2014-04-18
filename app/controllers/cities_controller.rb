class CitiesController < ApplicationController
  def show
    @city = City.includes(:users).friendly.find(params[:city_id])
    @users = @city.home_users.page(params[:page]).per(50)
    respond_with @users
  end
end
