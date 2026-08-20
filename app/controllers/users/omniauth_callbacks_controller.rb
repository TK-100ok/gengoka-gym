class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user&.persisted?
      sign_in_and_redirect user, event: :authentication
    else
      redirect_to new_user_registration_path, alert: "Googleログインに失敗しました。"
    end
  end

  def failure
    redirect_to new_user_session_path, alert: "Google認証に失敗しました。もう一度お試しください。"
  end
end