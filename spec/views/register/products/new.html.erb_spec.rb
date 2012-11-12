require 'spec_helper'

describe "register_products/new" do
  before(:each) do
    assign(:product, stub_model(Register::Product,
      :user => nil
    ).as_new_record)
  end

  it "renders new product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_products_path, :method => "post" do
      assert_select "input#product_user", :name => "product[user]"
    end
  end
end
