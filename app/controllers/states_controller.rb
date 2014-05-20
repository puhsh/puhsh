class StatesController < ApplicationController
  def index
    @states = City.us_states.order('full_state_name asc')
    respond_with @states
  end

  def show
    @cities = City.where(full_state_name: params[:name]).page(params[:page]).per(100).alpha
    respond_with @cities do |format|
      if @cities.any?
        @current_state_name = @cities.first.full_state_name
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def search
    @cities = City.search(params[:query], {page: params[:page], state_name: params[:name]})
    respond_with @cities
  end
end
