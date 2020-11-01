module Admin
  class PasswordResetsController < Admin::BaseController
    skip_before_action :authorize_operator
    layout "login"

    def new; end

    def create
      @operator = Operator.find_by(email: params[:password_reset][:email])
      if @operator
        @operator.create_reset_password_token
        Admin::OperatorMailer.password_reset(@operator, @operator.reset_password_token).deliver_later(wait: 10.seconds)
        redirect_to admin_login_path, notice: "パスワードをリセットするためのメールを送りました"
      else
        flash.now[:danger] = "入力いただいたメールアドレスは見つかりませんでした"
        render :new
      end
    end

    def edit
      @operator = Operator.find_by(email: params[:email])
      if @operator.password_reset_expired?
        redirect_to new_admin_password_reset_path, notice: "変更リンクの有効期限がきれています"
        return
      end
      unless @operator && @operator&.authenticated?(:reset_password_token, params[:id])
        redirect_to admin_login_path, notice: "ユーザの認証に失敗しました"
      end
    end

    def update
      @operator = Operator.find_by(email: params[:email])
      if @operator.password_reset_expired?
        redirect_to new_admin_password_reset_path, notice: "変更リンクの有効期限がきれています"
        return
      end
      unless @operator && @operator&.authenticated?(:reset_password_token, params[:id])
        redirect_to admin_login_path, notice: "ユーザの認証に失敗しました"
        return
      end
      if params[:operator][:password].empty?
        @operator.errors.add(:password, :blank)
        render :edit
      elsif @operator.update(operator_params)
        log_in @operator
        redirect_to admin_path, notice: "パスワードをリセットしました"
      else
        render :edit
      end
    end

    private

    def operator_params
      params.require(:operator).permit(:password, :password_confirmation)
    end
  end
end
