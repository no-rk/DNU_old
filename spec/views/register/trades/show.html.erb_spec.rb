require 'spec_helper'

describe "register_trades/show" do
  before(:each) do
    @trade = assign(:trade, stub_model(Register::Trade,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
