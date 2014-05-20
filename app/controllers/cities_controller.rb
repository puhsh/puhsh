class CitiesController < ApplicationController
  def show
    @city = City.where(full_state_name: params[:name], name: params[:city_name]).first

    if @city
      @posts = @city.posts.includes(:item, :user, :city, {post_images: :post}).page(params[:page]).per(10).recent
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
