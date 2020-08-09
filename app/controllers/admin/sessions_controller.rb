class Admin::SessionsController < Admin::BaseController
  skip_before_action :authorize_admin_user
  layout "login"

  def new
    redirect_to admin_path, notice: "既にログインしています" if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user&.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
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
