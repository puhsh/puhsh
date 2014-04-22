class CitiesController < ApplicationController
  def show
    @city = City.friendly.find(params[:city_id])
    @users = @city.home_users.where('users.posts_count >= 0').alpha.page(params[:page]).per(500)
    respond_with @users
  end
end
