class UsersController < ApplicationController
  before_action :check_user, only: [:edit, :update, :destroy]
  
  def index
    users = User.all
    @users = users.page(params[:page]).per(2)
  end
  
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(2)
  end
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # rake routesでみると
  # edit_user GET    /users/:id/edit(.:format) users#edit
  # 編集対象者は params[:id] で指定されます。
  # app/views/users/edit.html.erb がビューのファイルになります。
  def edit

  end
  
#  rake routesでみると
#           PUT    /users/:id(.:format)      users#update
#   更新対象者は params[:id]で指定される

#  処理管理用語は redirectするのでビューファイルはない
  def update
    if (@user.update(user_profile))
       #成功
       redirect_to @user  #変更したユーザーページへ
    else
       #失敗
       render 'edit'
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following_users.page(params[:page]).per(2)
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.follower_users.page(params[:page]).per(2)
    render 'show_follower'
  end
  
  


  private
  
  def check_user
    logged_in_user   #ログインしてなければ redirectされる
    @user = User.find(params[:id])
    if (current_user != @user)
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  def user_profile
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :place, :profile)
  end
end
