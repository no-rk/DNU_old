require 'spec_helper'

describe "register_products/show" do
  before(:each) do
    @product = assign(:product, stub_model(Register::Product,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
