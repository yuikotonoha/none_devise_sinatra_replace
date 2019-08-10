module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember #app/models/user.rb のメソッドを呼び出す
    cookies.permanent.signed[:user_id] = user.id #cookiesに暗号化したuser.idを代入
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 記憶トークンcookieに対応するユーザーを返す記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) #user_idという変数に、ログインしたユーザーのsession[:user_id]を代入

      #今ログインしているという意味のインスタンス変数@current_userに、usersテーブルからidで検索したユーザーの情報代入
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #ここの処理がよく分からない
      user = User.find_by(id: user_id) #ここの処理がよく分からない
      if user && user.authenticated?(cookies[:remember_token]) #ここの処理がよく分からない
        log_in user #ここの処理がよく分からない
        @current_user = user #ここの処理がよく分からない
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する（cookiesを削除してる）
  def forget(user)
    user.forget #app/models/user.rb #ユーザーのログイン情報を破棄する メソッドを呼び出す
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user) # 永続的セッションを破棄する app/helpers/sessions_helper.rb 同じファイル内のメソッドを呼び出す
    session.delete(:user_id) #一時的なセッションを破棄する
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end