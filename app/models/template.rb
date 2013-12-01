# -*- coding: utf-8 -*-
class Template < ActiveRecord::Base

  attr_accessible :name, :slug

  def self.supports_users?
    connection.table_exists? "templates_users"
  end

  validates_presence_of :name, :message => "Le nom doit être renseigné"

  has_and_belongs_to_many :users if supports_users?

  has_many :shows
  after_touch { |template| template.shows.each(&:touch) }

  has_many :radios
  after_touch { |template| template.radios.each(&:touch) }

  has_many :ftp_accounts, :dependent => :destroy

  liquid_methods :slug, :name

  validates_uniqueness_of :slug
  validates_presence_of :slug, :message => "Le lien doit être renseigné"
  validates_length_of :slug, :within => 3..20, :message => "Le lien doit contenir entre 3 et 20 lettres"
  validates_format_of :slug, :with => /^[a-z0-9-]*$/, :message => "Le lien ne peut contenir que des minuscules, des chiffres et des tirets"

  attr_accessor :resources

  before_create :install_resources
  after_destroy :destroy_resources

  def used?
    not shows.empty?
  end

  def resources=(resources)
    @resources = File.expand_path(resources)
  end

  def has_resources?
    File.exists?(resources_dir)
  end

  def install_resources
    FileUtils.mkdir resources_dir unless has_resources?
  end

  def destroy_resources
    FileUtils.rm_rf resources_dir if has_resources?
  end

  def before_validation
    self.slug = slug.downcase if slug
    true
  end

  def resources_dir
    root + slug
  end

  @@root = Rails.root + "templates"
  cattr_accessor :root

  def template(name)
    LiquidTemplate.new self, name
  end

  def liquid_file_system
    Liquid::LocalFileSystem.new resources_dir
  end

  @@default_slug = "cocoa"
  cattr_accessor :default_slug

  def self.default
    Template.find_by_slug(default_slug)
  end

  def to_param
    slug
  end

end

class Template::LiquidDropClass

  def url_for_assets
    "/templates/#{@object.slug}"
  end

  def javascript_include_tag
    view.javascript_include_tag(:defaults, :cache => false).to_s
  end

  def admin_link_tag
    "Hébergé par <a href=\"http://www.tryphon.eu\">Tryphon</a> sur <a href='http://bonnes-ondes.tryphon.eu'>Bonnes Ondes</a>"
  end

end
