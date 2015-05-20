class FavoriteController < ApplicationController
  # before_action :signed_in_user, only: [:create, :destroy]
  # before_action :signed_in_user
  # layout false

  before_action :correct_user,   only: :destroy

  # user.rb の【has_many :shops】のshops
  # お気に入りしたお店が、マイページにざっと表示される。

  def index
      # @shops = Shop.allだと、どんなユーザーのお気に入りも全て表示してしまう。なのでcurrent_userだけのにする。
  	  @shops = current_user.shops.all
  end

  # お気に入りボタンを押した時に、お店の保存をするメソッド。 
  #【if current_user.present? 〜end】で、現在のユーザーが存在しているなら。
  def create
    if current_user.present?
      	# 下記の検索条件で、最初の１件がもしないなら
      	unless Shop.find_by(name: params[:shop][:name],coordinate: params[:shop][:coordinate])
         # binding.pry
         # current_user.shops.newで新しいshopオブジェクトを作る。user_idのみが入っている。
         # 今のユーザーが、お気に入りとして保存したすべてのお店 のパラメーター→→@shopにいれている。
          @shop = current_user.shops.new(shop_params)

          # 上の１行or下の２行は、同じこと。
          #Shop.newで、新しいshopオブジェクトが保存生成。shop_paramsには、お気に入りのお店のidが入り、@shopへ代入。
          #shopモデルの、ユーザーid（@shop.user_id）に、現在のログインしているユーザー（current_user.id）を代入。
          # @shop = Shop.new(shop_params)
          # @shop.user_id = current_user.id
          @shop.save
        end
    else
         #【現在、ユーザーがないなら】
          redirect_to root_path
    end

    # 店の最初の１件があった場合。ビューに表示しない。   
    render :nothing => true

  end
  
  # お気に入りで保存した店を削除。Shop.find_by(id: params[:id])は、上のcreateの時と、同様。
  # destroyメソッドの時は、viewではshopの変数を使わないから、＠shopではなく、shopのみ。
  # 他で使われることがないものは、インスタンス変数にしない。
  def destroy
        shop = Shop.find_by(id: params[:id])
        shop.destroy
        # binding.pry
        redirect_to favorite_index_path
  end

  #Strong parameterで、セキュリティに気をつける。データをハッシュで、受け取る場合は、こちらのpermitの後に書かないと、
  # セキュリティ上の問題がおこる。
  private

  	def shop_params
  		params.require(:shop).permit(:name, :image_url, :display_phone, :location_display_address, :star, :review_count, :coordinate, :url)
  	end


    def correct_user
      @shop = current_user.shops.find_by(id: params[:id])
      redirect_to favorite_index_path if @shop.nil?
    end

end
