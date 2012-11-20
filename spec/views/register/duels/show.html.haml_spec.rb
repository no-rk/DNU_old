require 'spec_helper'

describe "register/duels/show" do
  before(:each) do
    @register_duel = assign(:register_duel, stub_model(Register::Duel,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
