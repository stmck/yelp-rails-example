class HomeController < ApplicationController
  def index
  end

  def search
    parameters = { term: params["japanese"], limit: 16 }
    render json: Yelp.client.search('Japan', { term: 'food' })
  end
end
