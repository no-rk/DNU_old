require 'spec_helper'

describe "register_products/index" do
  before(:each) do
    assign(:register_products, [
      stub_model(Register::Product,
        :user => nil
      ),
      stub_model(Register::Product,
        :user => nil
      )
    ])
  end

  it "renders a list of register_products" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
