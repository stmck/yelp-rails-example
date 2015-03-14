class HomeController < ApplicationController
  # ユーザがログインしていないと"show"にアクセスできない
  before_action :authenticate_user!, only: :show

  def index
  end

def search
	#binding.pry
    parameters = { term:'野菜-ベジタリアン', limit: 20 }
    #parameters = { term:'インド', limit: 20 }
    render json: Yelp.client.search(params[:term], parameters) 
end

end