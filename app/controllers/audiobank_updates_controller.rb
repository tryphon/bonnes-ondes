class AudiobankUpdatesController < ApplicationController

  skip_filter :login_required

  def create
    audiobank_content.update_document(audiobank_document).save if audiobank_content
    render :json => {"status" => "ok"}
  end

  private

  def audiobank_document
    @audiobank_document ||= Audiobank::Document.new(params[:document] || {})
  end

  def audiobank_content
    @content ||= AudiobankContent.find_by_audiobank_id(audiobank_document.id) if audiobank_document.id
  end

end
