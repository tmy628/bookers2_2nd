class BooksController < ApplicationController
  before_action :authenticate_user!
  # ログイン済ユーザーのみにアクセスを許可する
  # コントローラーの先頭に記載することで、そこで行われる処理はログインユーザーによってのみ実行可能となる
  before_action :correct_user, only: [:edit, :update]
  # サインインしているユーザーを取得する

  def new
  end

  def create
    @book = Book.new(book_params)  # 何を新しく保存するのかを指定
    @book.user_id = current_user.id # 誰が投稿したのかを指定
    @book.save

    if @book.update(book_params) # もし保存ができたら
      flash[:success] = "Book was successfully created."
      # サクセスメッセージを表示
      redirect_to book_path(@book.id) # 投稿詳細画面へ遷移

    else # でなければ
      @books = Book.all
      @user = current_user
      render action: :index # indexへ遷移
      # indexのアクションをスルーしてindex.htnl.erbへ
      # renderはredirect_toと異なりアクションを経由せずそのままビューを出力するので、ビューで使う変数はrenderの前にそのアクションで定義しないといけない
    end
  end

  def index
    @user = current_user
    # 現在ログインしているユーザーの情報を取得できるメソッド

    @book = Book.new
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.all

    @user = @book.user
    @booknew = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id]) # 何を更新するのかを指定

    if @book.update(book_params) # もし更新ができたら
      flash[:success] = "Book was successfully updated."
      # サクセスメッセージを表示
      redirect_to book_path(@book.id) # 投稿詳細画面へ遷移

    else # でなければ
      render action: :edit # editへ遷移
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def correct_user # URLを入力しても、他のユーザが投稿した投稿の編集画面、および他のユーザの編集画面には遷移できないように設定
    @book = Book.find(params[:id])
    @user = @book.user
    if current_user != @user
      redirect_to books_path
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

end
