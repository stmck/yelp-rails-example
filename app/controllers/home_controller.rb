class HomeController < ApplicationController
  # ユーザがログインしていないと"show"にアクセスできない
  # before_action :authenticate_user!, only: :show

  def index
  end

  def search
    parameters = { term:'野菜-ベジタリアン', limit: 20 }
    #parameters = { term:'インド', limit: 20 }
    #binding.pry
    render json: Yelp.client.search(params[:term], parameters) 
  end

end