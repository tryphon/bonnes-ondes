require 'httparty'

class Audiobank::Account
  include HTTParty
  base_uri 'audiobank.tryphon.org'
  format :json

  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def username
    token.split(':').first
  end

  def password
    token.split(':').last
  end

  def default_options
    {:basic_auth => {:username => username, :password => password}}
  end

  def document(id)
    Rails.logger.info "Request document information : #{id}"
    response = self.class.get "/documents/#{id}.json", default_options
    Audiobank::Document.new(response) if response.code == 200
  end

end
