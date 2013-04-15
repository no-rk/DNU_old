require 'spec_helper'

describe "register/skills/new" do
  before(:each) do
    assign(:register_skill, stub_model(Register::Skill).as_new_record)
  end

  it "renders new register_skill form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_skills_path, :method => "post" do
    end
  end
end
