require 'httparty'

class Audiobank::Account
  include HTTParty
  base_uri 'audiobank.tryphon.org'
  headers "Content-Type" => "application/json"
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
    { :basic_auth => {:username => username, :password => password} }
  end

  def get(url, &block)
    process_response self.class.get(url, default_options), &block
  end

  def post(url, attributes = {}, &block)
    process_response self.class.post(url, default_options.merge(:body => attributes.to_json)), &block
  end

  def process_response(response, &block)
    if block_given?
      yield response
    else
      response
    end
  end

  def document(id)
    Rails.logger.info "Request document information : #{id}"
    get "/documents/#{id}.json" do |response|
      Audiobank::Document.new(response) if response.code == 200
    end
  end

  def documents
    @documents ||= Audiobank::Documents.new(self)
  end

end
