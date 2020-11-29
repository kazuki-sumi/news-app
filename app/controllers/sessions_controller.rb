class SessionsController < ApplicationController
  def new ;end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user&.authenticate(params[:password])
      user_log_in(user)
      params[:session][:remember_me] == "1" ? user_remember(user) : user_forget(user)
      redirect_back_or(root_path)
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    user_log_out if user_logged_in?
    redirect_to login_path, notice: "ログアウトしました"
  end
end
