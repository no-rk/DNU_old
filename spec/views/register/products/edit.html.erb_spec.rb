require 'spec_helper'

describe "register_products/edit" do
  before(:each) do
    @product = assign(:product, stub_model(Register::Product,
      :user => nil
    ))
  end

  it "renders the edit product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_products_path(@product), :method => "post" do
      assert_select "input#product_user", :name => "product[user]"
    end
  end
end
