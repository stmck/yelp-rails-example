class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates :username, presence: true, uniqueness: true

  # providerがある場合（Twitter経由で認証した）は、
  # passwordは要求しないようにする。
  def password_required?
    super && provider.blank?
  end

def self.from_omniauth(auth)
    # providerとuidでUserレコードを取得する
    # 存在しない場合は、ブロック内のコードを実行して作成する
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      # auth.provider には "twitter"、
      # auth.uidには twitterアカウントに基づいた個別のIDが入っている
      # first_or_createメソッドが自動でproviderとuidを設定してくれるので、
      # ここでは設定は必要ない

      # binding.pry
      #user.username = auth.info.nickname # twitterで利用している名前が入る
      #user.email = create_unique_email

      #■パターン1→→パターン２をリファクタリングした場合。（twitterと、FBをまとめた。他のSnsログインを使うとなると、書き換え）
      if auth.provider == "twitter"
        user.email = create_unique_email # twitterの場合
        user.username = auth.info.nickname
      elsif auth.provider == "facebook"
        user.username = auth.info.name
        user.email = auth.info.email # その他の場合
      end

      # ■パターン２→→２つ書いた場合。（twitterと、FBをバラバラに書けば、この様になる。）

      # if auth.provider == "twitter"
      #   user.email = create_unique_email # twitterの場合
      # elsif auth.provider == "facebook"
      #   user.email = auth.info.email # その他の場合
      # end

      # if auth.provider == "facebook"
      #   user.username = auth.info.name # FBの場合
      # else 
      #   user.username = auth.info.nickname # その他の場合 
      # end

    end
  end

# Devise の RegistrationsController はリソースを生成する前に self.new_sith_session を呼ぶ
  # つまり、self.new_with_sessionを実装することで、サインアップ前のuserオブジェクトを初期化する
  # ときに session からデータをコピーすることができます。
  # OmniauthCallbacksControllerでsessionに値を設定したので、それをuserオブジェクトにコピーします。
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  # providerがある場合（Twitter経由で認証した）は、
  # passwordは要求しないようにする。
  def password_required?
    super && provider.blank?
  end


   # プロフィールを変更するときによばれる
   #DeviseにOmniAuthのインストールと設定
  def update_with_password(params, *options)
    # パスワードが空の場合
    if encrypted_password.blank?
      # パスワードがなくても更新できる
      update_attributes(params, *options)
    else
      super
    end
  end

  # 通常サインアップ時のuid用、Twitter OAuth認証時のemail用にuuidな文字列を生成
  def self.create_unique_string
    SecureRandom.uuid
  end
 
  # twitterではemailを取得できないので、適当に一意のemailを生成
  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end



end
