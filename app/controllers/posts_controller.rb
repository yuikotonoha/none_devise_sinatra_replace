class PostsController < ApplicationController

  # ログインしていないユーザーに対する制限
  # app/controllers/application_controller.rb からメソッド呼び出す
  before_action :logged_in_user, only: [:create, :destroy]

  # 商品一覧を取得しインスタンス変数に代入
  # def index
  #   @posts = Post.all
  # end


  # Ransack用index
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
    @category = Post.group(:category)
    # binding.pry
  end


  # 商品を検索
  def search
    post_search = PostSearch.new(params_post_search)
    @posts = post_search.execute
  end

  # 商品の詳細画面を表示
  def show
    @post = Post.find_by(id: params[:id])
    @comments = Comment.where(post_id: params[:id])
    @comment = Comment.new

    # お気に入りしているか判定
    @like_check = Like.find_by(post_id: cookies[:post_id], user_id: current_user.id)

    # お気に入りの数をカウント
    @like_count = Like.where(post_id: params[:id]).count

    #今見ている商品の口コミが投稿された場合、comment_controllerにpost_idを渡すための処理
    cookies[:post_id] = params[:id]
  end

  # オブジェクトを新規作成
  def new
    @post = Post.new
  end

  # postで投げられたデータを受け取る
  def create
    # binding.pry
    @post = Post.create(
        title: post_params[:title],
        category: post_params[:category],
        product_image: post_params[:product_image],
        user_id: current_user.id)
    if @post.save
      flash[:success] = '女装アイテムを投稿しました'
      redirect_to root_path
    else
      flash[:danger] = '女装アイテムの投稿に失敗しました'
      redirect_to root_path
    end
  end


  # 商品編集画面に移動
  def edit
    @post = Post.find(params[:id])
  end

  # 商品情報を更新
  def update
    post = Post.find(params[:id])
    post.update(post_params)
    flash[:success] = '女装アイテムを投稿しました'
    redirect_to user_path(current_user.id)
  end


  # ログインしていないユーザーをトップにリダイレクト
  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

  # 商品を削除
  def destroy
    # binding.pry
    post = Post.find(params[:id])
    post.destroy

    flash[:danger] = '女装アイテムを削除しました'
    redirect_to root_path
  end



  private
  # 投稿された内容のStrong Parameters
  def post_params
    params.require(:post).permit(:title, :category, :product_image, :product_link)
  end

  # 検索機能のStrong Parameters
  def params_post_search
    params.permit(:search_title)
  end

end