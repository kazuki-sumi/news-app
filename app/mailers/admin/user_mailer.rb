module Admin
  class OperatorMailer < ApplicationMailer
    def password_reset(operator, reset_password_token)
      @operator = operator
      @operator.reset_password_token = reset_password_token
      mail to: @operator.email, subject: "パスワード変更メール"
    end
  end
end
