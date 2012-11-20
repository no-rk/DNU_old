require 'spec_helper'

describe "register/competitions/show" do
  before(:each) do
    @register_competition = assign(:register_competition, stub_model(Register::Competition,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
