class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :update, :edit, :destroy, :current_user]
  before_action :check_current_user, only: [:edit, :update, :destroy]

  def index
    @pictures = Picture.all.order(created_at: "desc")
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def new
    @picture = Picture.new
  end

  def edit
    if @picture.user_id == current_user.id
    else
      redirect_to user_path(current_user.id)
    end
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    # respond_to do |format|
      if @picture.save
        # format.html { redirect_to @picture, notice: '作成されました。' }
        redirect_to picture_path(@picture.id)
        #指定したページにリダイレクト
        # redirect_to(リダイレクト先のパス [, status: ステイタスコード, オプション])
        PictureMailer.picture_mail(@picture).deliver
      else
        render :new
      end
    # end
  end

  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: '更新されました。' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: '削除しました。' }
    end
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private
  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(:image, :image_cache, :content)
  end

  def check_current_user
    user = User.find(current_user.id)
    if user.id != current_user.id
      redirect_to blogs_path, notice: "この操作はできません"
    end
  end
end
