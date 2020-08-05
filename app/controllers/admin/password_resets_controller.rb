module Admin
  class PasswordResetsController < Admin::BaseController
    skip_before_action :authorize_admin_user
    layout "login"

    def new; end

    def create
      @user = User.find_by(email: params[:password_reset][:email])
      if @user
        @user.create_reset_password_token
        Admin::UserMailer.password_reset(@user, @user.reset_password_token).deliver_later(wait: 10.seconds)
        redirect_to admin_login_path, notice: "パスワードをリセットするためのメールを送りました"
      else
        flash.now[:danger] = "入力いただいたメールアドレスは見つかりませんでした"
        render :new
      end
    end

    def edit
      @user = User.find_by(email: params[:email])
      if @user.password_reset_expired?
        redirect_to new_admin_password_reset_path, notice: "変更リンクの有効期限がきれています"
        return
      end
      unless @user && @user.authenticated?(:reset_password_token, params[:id])
        redirect_to admin_login_path, notice: "ユーザの認証に失敗しました"
      end
    end

    def update
      @user = User.find_by(email: params[:email])
      if @user.password_reset_expired?
        redirect_to new_admin_password_reset_path, notice: "変更リンクの有効期限がきれています"
        return
      end
      unless @user && @user.authenticated?(:reset_password_token, params[:id])
        redirect_to admin_login_path, notice: "ユーザの認証に失敗しました"
        return
      end
      if params[:user][:password].empty?
        @user.errors.add(:password, :blank)
        render :edit
      elsif @user.update(user_params)
        log_in @user
        redirect_to admin_path, notice: "パスワードをリセットしました"
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
