class CitiesController < ApplicationController
  def show
    if params[:city_id]
      @city = City.friendly.find(params[:city_id]) 
    else
      @city = City.where(full_state_name: params[:name], name: params[:city_name]).first
    end

    if @city
      @posts = @city.posts.includes(:item, :user, :city, {post_images: :post}).page(params[:page]).per(20).recent
      @founding_user = @city.home_users.where('users.posts_count > ?', 1).oldest.first
    end

    respond_with @posts do |format|
      if @posts
        format.html 
      else
        format.html { redirect_to root_url }
      end
    end
  end
end
