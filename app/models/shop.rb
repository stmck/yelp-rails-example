class Shop < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }

  validates :user_id, presence: true
  #created_at DESCは、新しいものから古い順への降順
  #user_id属性が存在していることの検証、、これをいれると、お気に入り登録ができなくなった。
  # 理由：user_idのカラムが、shop.rb のshopsになかったから。
end
