class HomeController < ApplicationController
  def index
  end

def search
	#binding.pry
    parameters = { term:'野菜-ベジタリアン', limit: 16 }
    render json: Yelp.client.search(params[:term], parameters) 
end

end