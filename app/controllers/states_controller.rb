class StatesController < ApplicationController
  def index
    @states = City.us_states.order('full_state_name asc')
    respond_with @states
  end

  def show
    @cities = City.where(full_state_name: params[:name]).alpha
    @current_state_name = @cities.first.full_state_name
    respond_with @cities
  end
end
