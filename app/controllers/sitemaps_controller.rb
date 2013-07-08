class SitemapsController < ApplicationController

  skip_before_filter :login_required

  def show
    @radio = Radio.find_by_slug(params[:id])
    @shows = @radio ? @radio.shows : [ Show.find_by_slug params[:id] ]

    raise ActiveRecord::RecordNotFound if [@radio, @shows].all?(&:blank?)
    render :layout => false
  end

end
