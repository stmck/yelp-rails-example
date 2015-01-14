class HomeController < ApplicationController
  def index
  end

  def search
    parameters = { term: params[:term], limit: 16 }
    render json: Yelp.client.search('Tokyo', parameters)
  end
end
