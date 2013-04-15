require 'spec_helper'

describe "register/skills/edit" do
  before(:each) do
    @register_skill = assign(:register_skill, stub_model(Register::Skill))
  end

  it "renders the edit register_skill form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_skills_path(@register_skill), :method => "post" do
    end
  end
end
