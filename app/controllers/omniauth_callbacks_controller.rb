class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    sign_in_and_redirect(
      Spree::User.from_omniauth(request.env["omniauth.auth"])
    )
  end

  def failure
    error_message = request.env["omniauth.error"].to_s
    flash[:error] = t("devise.oidc.failure", error: error_message)
    super
  end
end