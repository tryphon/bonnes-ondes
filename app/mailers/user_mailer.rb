class UserMailer < ActionMailer::Base

  default :from => "Bonnes-Ondes <bonnes-ondes@tryphon.eu>"

  def new_password(user, new_password)
    @user, @new_password = user, new_password
    mail :to => user.email, :subject => "[Bonnes Ondes] Votre mot de passe"
  end

  def signup_notification(user)
    @user = user
    @url  = admin_activate_path user.activation_code
    mail :to => user.email, :subject => "[Bonnes Ondes] Activation de votre compte Bonnes-Ondes"
  end

  def activation(user)
    @user = user
    @url  = admin_login_path
    mail :to => user.email, :subject => "[Bonnes Ondes] Bienvenue"
  end

end
