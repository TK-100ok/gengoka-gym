class Users::PasswordsController < Devise::PasswordsController
  def create
    super
  rescue Resend::Error::InvalidRequestError
    redirect_to new_user_password_path, alert: "メール送信に失敗しました。時間をおいて再度お試しください。"
  end
end