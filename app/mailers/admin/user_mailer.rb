module Admin
  class UserMailer < ApplicationMailer
    def password_reset(user, reset_password_token)
      @user = user
      @user.reset_password_token = reset_password_token
      mail to: @user.email, subject: "パスワード変更メール"
    end
  end
end
