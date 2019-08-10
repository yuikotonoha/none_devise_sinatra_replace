class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase } #email属性を小文字に変換してメールアドレスの一意性を保証する
  # 登録時のバリデーション
  validates :nickname, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, #emailは空白にできない、文字数は255文字まで
            format: { with: VALID_EMAIL_REGEX }, #正規表現
            uniqueness: { case_sensitive: false } #同じemailは登録できない

  validates :image, presence: true, length: { maximum: 255 }

  has_secure_password #パスワードのハッシュ化

  #空白スペースなどは設定不可、最低文字数は6文字、プロフィール編集画面ではパスワード入力なしで更新可能
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す（８章の「8.2.4 レイアウトの変更をテストする」でも使う部分)
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # remember_token = User.new_token

    #remember_digestカラムの値をハッシュ値で上書きしている引数は(remember_token)
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する（データベースから削除してる）
  def forget
    update_attribute(:remember_digest, nil)
  end

end
