class CitiesController < ApplicationController
  def show
    @city = City.includes(:users).friendly.find(params[:city_id])
    @users = @city.home_users.where('users.posts_count > 0').page(params[:page]).per(50)
    respond_with @users
  end
end
