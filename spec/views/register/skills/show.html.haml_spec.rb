require 'spec_helper'

describe "register/skills/show" do
  before(:each) do
    @register_skill = assign(:register_skill, stub_model(Register::Skill))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
