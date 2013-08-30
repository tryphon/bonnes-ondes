describe LiquidTemplate do

  let(:theme) { Factory(:template) }
  subject { LiquidTemplate.new(theme, "dummy") }

  describe "#file" do

    it "should be :name.liquid file in theme directory" do
      subject.file.should == theme.resources_dir + "dummy.liquid"
    end

  end

  describe "#liquid_template" do

    let(:content) { "content" }
    let(:liquid_template) { mock }

    it "should create a Liquid::Template with file content" do
      subject.stub :file => mock(:read => content)
      Liquid::Template.should_receive(:parse).with(content).and_return(liquid_template)
      subject.liquid_template.should == liquid_template
    end

  end

  describe "render" do

    let(:liquid_template) { mock :render => "rendered" }

    before(:each) do
      subject.stub :liquid_template => liquid_template
    end

    it "should render liquid template" do
      liquid_template.should_receive(:render).and_return("rendered")
      subject.render("template").should == "rendered"
    end

    it "should render by registering theme's liquid_file_system" do
      theme.stub :liquid_file_system => mock
      liquid_template.should_receive(:render).with(anything, :registers => hash_including({ :file_system => theme.liquid_file_system }))
      subject.render("template")
    end

    it "should render by assigning 'theme'" do
      liquid_template.should_receive(:render).with(hash_including("theme" => theme), anything)
      subject.render("template", :dummy => true)
    end

  end

  describe "#==" do

    it "should be equal to another LiquidTemplate with the same theme and name" do
      subject.should == Theme::LiquidTemplate.new(theme, subject.name)
    end

  end

end
