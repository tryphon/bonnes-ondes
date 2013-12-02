require 'spec_helper'

describe FtpAccount do

  let(:user) { Factory :user }
  let(:template) { Factory :template }

  subject { FtpAccount.new :user => user, :template => template }

  describe "#set_defaults" do

    it "should define home as template resources_dir" do
      subject.set_defaults
      subject.homedir.should == template.resources_dir.to_s
    end

    it "should define userid with FtpAccount.userid" do
      subject.set_defaults
      subject.userid.should == FtpAccount.userid(user, template)
    end

    it "should define a password with SecureRandom" do
      SecureRandom.should_receive(:hex).and_return("random")
      subject.set_defaults
      subject.password.should == "random"
    end

  end

  describe ".userid" do

    def user(login)
      double :login => login
    end

    def template(slug)
      double :slug => slug
    end

    it "should use user.login and template.slug" do
      FtpAccount.userid(user("login"), template("template")).should == "login+template"
    end

  end

  describe "url" do

    it "should return a ftp url with userid" do
      subject.userid = "userid"
      subject.url.should == "ftp://userid@ftp.bonnes-ondes.fr"
    end

  end

  describe ".associated" do

    before(:each) do
      user.templates << template
    end

    it "should use user email and template slug as userid" do
      FtpAccount.associated(user).map { |a| [ a.user, a.template ] }.should == [[ user, template ]]
    end

  end

end
