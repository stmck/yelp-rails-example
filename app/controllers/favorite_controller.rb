class FavoriteController < ApplicationController
  
  # お気に入りしたお店が、マイページにざっと表示される。
  def index
  	  	@shops = Shop.all
  end

  # お気に入りボタンを押した時に、お店の保存をするメソッドにしたい。 
  def create
  	# binding.pry
  	# 下記の検索条件で、最初の１件がもしないなら
  	unless Shop.find_by(name: params[:shop][:name],coordinate: params[:shop][:coordinate])
      @shop = Shop.new(shop_params)
      @shop.save
    end 
    # 店の最初の１件があった場合。ビューに表示しない。   
    render :nothing => true

  end
  
  # お気に入りで保存した店を削除
  def destroy
        @shop = Shop.find(params[:id])
        @shop.destroy
        redirect_to favorite_index_path
  end

  #Strong parameterで、セキュリティに気をつける。データをハッシュで、受け取る場合は、こちらのpermitの後に書かないと、
  # セキュリティ上の問題がおこる。
  private

  	def shop_params
  		params.require(:shop).permit(:name, :image_url, :display_phone, :location_display_address, :star, :review_count, :coordinate, :url)
  	end

end
