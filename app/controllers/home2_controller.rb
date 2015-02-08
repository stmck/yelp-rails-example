class HomeController < ApplicationController
  def index
  end

  def search
    # render json: Yelp.client.search('Tokyo', { term:'ビーガン',term:'インド料理',term:'ベジタリアン'})
    render json: Yelp.client.search('Tokyo', { term:'インド料理',term:'ベジタリアン'})
    #できないrender json: Yelp.client.search('Tokyo', { term: 'インド料理' }, { term: 'ベジタリアン' }, { term: 'ビーガン' })
  end

  def search
    parameters = { term:'インド料理', limit: 50 }
    render json: Yelp.client.search('Tokyo', parameters)
  end


end
