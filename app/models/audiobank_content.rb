# -*- coding: utf-8 -*-
class AudiobankContent < Content

  @@audiobank_base_url = "http://audiobank.tryphon.org"
  cattr_accessor :audiobank_base_url

  validates_presence_of :audiobank_id, :on => :create
  validates_numericality_of :audiobank_id, :allow_nil => true

  validates_length_of :audiobank_cast, :is => 8, :wrong_length => "L'identifiant AudioBank doit faire 8 caractères", :allow_blank => true
  validates_format_of :audiobank_cast, :with => /^[a-z0-9]*$/, :message => "L'identifiant AudioBank ne peut contenir que des minuscules et des chiffres", :allow_blank => true

  def ready?
    audiobank_cast.present?
  end

  def playlist_url
    cast_url
  end

  def support_format?(format)
    [ :mp3, :ogg ].include? format
  end

  def content_url(options = {})
    options[:format] ||= :ogg
    "#{cast_url}.#{options[:format]}"
  end

  def cast_url
    "#{audiobank_base_url}/casts/#{audiobank_cast}"
  end

  def document_url
    "#{audiobank_base_url}/documents/show/#{audiobank_id}"
  end

  attr_accessor :audiobank_project

  def audiobank_project
    @audiobank_project ||= episode.try(:show).try(:audiobank_project)
  end

  def audiobank_enabled?
    audiobank_project.present?
  end

  attr_accessor :create_document

  def create_document?
    [true, "1"].include?(create_document)
  end

  before_validation_on_create :create_document!

  def create_document!
    return unless audiobank_id.nil? and create_document?
    self.audiobank_id = DocumentBuilder.new(self).create
  end

  class DocumentBuilder

    attr_accessor :content

    def initialize(content)
      @content = content
    end

    delegate :name, :episode, :audiobank_project, :to => :content

    def default_name?
      name == "Intégrale"
    end

    def name_without_default
      name unless default_name?
    end

    def title
      [ episode.try(:title), name_without_default ].compact.join(" - ")
    end

    def description
      description = (episode.try(:description) || "created by Bonnes-Ondes")
      truncate description, 250
    end

    def truncate(text, length)
      omission = "..."
      l = length - omission.mb_chars.length
      chars = text.mb_chars
      (chars.length > length ? chars[0...l] + omission : text).to_s
    end

    def create
      attributes = { :title => title, :description => description }
      puts self.inspect
      audiobank_project.documents.create(attributes).id
    end

  end

  validate_on_create :check_audiobank_document_exists

  def check_audiobank_document_exists
    return unless audiobank_id

    unless audiobank_project
      errors.add_to_base "Vous n'avez pas associé de compte AudioBank"
    else
      unless audiobank_project.exists? audiobank_id
        errors.add :audiobank_id, "Le document AudioBank #{audiobank_id} n'a pu être trouvé"
      end
    end
  end

  before_save :update_document, :unless => :updated_document?

  attr_accessor :updated_document
  alias_method :updated_document?, :updated_document

  def update_document(document = nil)
    document ||= audiobank_project.document(audiobank_id)
    if document
      self.audiobank_cast = document.cast
      self.duration = (document.length / 60.0).round if document.length

      self.updated_document = true
    end
    self
  end

end
