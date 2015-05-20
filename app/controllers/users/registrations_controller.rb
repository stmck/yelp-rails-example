class Users::RegistrationsController < Devise::RegistrationsController
	
	# もし現在のuserのproviderに入っているものが、FB or twitterなら。
	# プロフィール変更ページのemailは、readonlyにする。
	# superは、edit以外の他メソッドも、ここに書いてなくても、
	# Devise::RegistrationsControllerのものを継承する！。rake routesで確認できる。

	def edit
	  if current_user.provider == "facebook" or current_user.provider == "twitter"
	  	@readonly = "readonly"
      else
	  	@readonly = false
      end
      super
	end	

end
