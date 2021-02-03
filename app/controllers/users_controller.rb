class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_current_user, only: [:update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      if @user.save
        redirect_to new_session_path, notice: "ログインしてください"
      else
        render :new, notice: "失敗しました。"
      end
  end

  def show
    if current_user.id != @user.id
    redirect_to user_path(current_user.id)
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(update_params)
        format.html { redirect_to @user, notice: 'アップデートされました。' }
      else
        format.html { render :edit, notice: "失敗しました。" }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: '削除されました。' }
    end
  end

  def favorite
    @favorites = Favorite.where(params[:id])
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image)
  end

  def check_current_user
  user = User.find(params[:id])
   if user.id != params[:id].to_i
    redirect_to new_user_path, notice: "この操作はできません。"
   end
  end
end
