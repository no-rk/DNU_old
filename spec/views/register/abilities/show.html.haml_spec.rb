require 'spec_helper'

describe "register/abilities/show" do
  before(:each) do
    @register_ability = assign(:register_ability, stub_model(Register::Ability,
      :user => nil,
      :day => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
