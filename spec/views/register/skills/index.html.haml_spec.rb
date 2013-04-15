require 'spec_helper'

describe "register/skills/index" do
  before(:each) do
    assign(:register_skills, [
      stub_model(Register::Skill),
      stub_model(Register::Skill)
    ])
  end

  it "renders a list of register/skills" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
