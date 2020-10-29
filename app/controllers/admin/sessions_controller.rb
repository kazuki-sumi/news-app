class Admin::SessionsController < Admin::BaseController
  skip_before_action :authorize_operator
  layout "admin_login"

  def new
    redirect_to admin_path, notice: "既にログインしています" if logged_in?
  end

  def create
    operator = Operator.find_by(email: params[:session][:email].downcase)
    if operator && operator&.authenticate(params[:session][:password])
      log_in(operator)
      params[:session][:remember_me] == "1" ? remember(operator) : forget(operator)
      redirect_back_or(admin_path)
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to admin_login_path, notice: "ログアウトしました"
  end
end
