class CitiesController < ApplicationController
  # TODO this is a n+1 mess
  def show
    @city = City.includes(posts: [:item, :user, :post_images]).friendly.find(params[:city_id])
    @posts = @city.posts.page(params[:page]).per(10).recent
    respond_with @posts
  end
end
