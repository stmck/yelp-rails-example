class ShopsController < ApplicationController
  # ユーザがログインしていないと"show"にアクセスできない
  # before_action :authenticate_user!, only: :show

  def index
  end

  # お気に入りで保存した店を削除
  def destroy
    # User.find(params[:id]).destroy
        # flash[:success] = "お気に入りから削除しました。"
        # @shop = Shop.find(params[:id])
        @shop.destroy
        redirect_to favorite_index_path
  end

  private

  	def shop_params
  		params.require(:shop).permit(:name, :image_url, :display_phone, :location_display_address, :star, :review_count, :coordinate, :url)
  	end

    def correct_user
      @shop = current_user.shops.find_by(id: params[:id])
      redirect_to favorite_index_path if @shop.nil?
    end

end
