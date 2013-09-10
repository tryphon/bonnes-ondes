# -*- coding: utf-8 -*-
class Admin::AccountController < ApplicationController

  include AuthenticatedSystem

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default admin_path
      flash[:notice] = "Bienvenue sur votre compte"
    else
      flash[:failure] = "Mauvais login ou mot de passe"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user

    flash[:notice] = "Votre compte est créé. Vous allez recevoir un email pour l'activer."
    redirect_to admin_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Vous n'êtes plus connecté"
    redirect_to public_path
  end

  def recover_password
    @email = params[:email]

    if request.post?
      user = User.find_by_email(@email)
      unless user.nil?
        user.change_password
        user.save!
        flash[:success] = "Votre nouveau de passe a été envoyé à #{user.email}"
        redirect_to admin_login_path
      else
        flash[:failure] = "Aucun compte Bonnes-Ondes ne correspond à cet email"
      end
    end
  end

  def activate
    if params[:code]
      @user = User.find_by_activation_code(params[:code])
      if @user and @user.activate
        flash[:notice] = "Votre compte a été activé"
      else
        flash[:error] = "Impossible d'activer votre compte."
      end
    else
      flash.clear
    end

    redirect_back_or_default admin_path
  end
end
