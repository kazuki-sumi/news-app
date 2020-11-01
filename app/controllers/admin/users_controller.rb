# TODO 後々削除か移管
class Admin::UsersController < Admin::BaseController
  before_action :authorize_admin_user

  def index
    @admin_users = User.with_role(:admin)
  end

  def show
    @admin_user = User.with_role(:admin).find(params[:id])
  end

  def new
    @admin_user = User.new
  end

  def create
    @admin_user = User.new(admin_params)
    if @admin_user.save
      redirect_to admin_users_path, notice: "ユーザを登録しました"
    else
      render :new
    end
  end

  def edit
    @admin_user = User.with_role(:admin).find(params[:id])
  end

  def update
    @admin_user = User.with_role(:admin).find(params[:id])
    if @admin_user.update(admin_params)
      redirect_to admin_path(@admin_user), notice: "ユーザの情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @admin_user = User.with_role(:admin).find(params[:id])
    @admin_user.destroy!
    redirect_to admin_users_path, notice: "ユーザの情報を削除しました"
  end

  private

    def admin_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end
end
