class FtpAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :template

  attr_accessible :user, :template

  validates_presence_of :userid, :passwd, :homedir
  validates_presence_of :user_id, :template_id

  before_validation :set_defaults

  def set_defaults
    self.userid ||= self.class.userid(user, template)
    self.passwd ||= SecureRandom.hex
    self.homedir ||= template.resources_dir if template
    self
  end

  def self.userid(user, template)
    "#{user.login}+#{template.slug}" if user and template
  end

  def homedir=(homedir)
    write_attribute :homedir, homedir.to_s
  end

  def password
    passwd
  end

  def url
    "ftp://#{userid}@ftp.bonnes-ondes.fr"
  end

  def self.associated(user_or_template)
    if user_or_template.respond_to?(:templates)
      users = [user_or_template]
      templates = user_or_template.templates
    else
      templates = [user_or_template]
      users =  user_or_template.users
    end

    users.product(templates).collect do |user, template|
      where(:user_id => user, :template_id => template).first_or_initialize
    end
  end

end
