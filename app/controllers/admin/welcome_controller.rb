class Admin::WelcomeController < ApplicationController

  include AuthenticatedSystem

  def show
    @episodes_last =  Episode.find :all, :order => "created_at DESC", :limit => 10
  end

end
