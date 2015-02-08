class HomeController < ApplicationController
  def index
  end

  def search

    # parameters = { term: params[:term], limit: 16 }
    # render json: Yelp.client.search('Tokyo', parameters)

    parameters = { term:'野菜', limit: 20 }
    render json: Yelp.client.search('Tokyo', parameters)

    #termは、複数。ビーガン、インド料理、ベジタリアン、マクロビの複数カテゴリ設定にはできない？
    #場所は、日本全国から検索したい。 ユーザーが【場所】と、【食べ物の名前】などを入力して、その地域のお店がでる。
    #ちずの連動 ヴィーガン

  end
end
	