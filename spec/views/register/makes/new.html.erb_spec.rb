require 'spec_helper'

describe "register_makes/new" do
  before(:each) do
    assign(:make, stub_model(Register::Make,
      :user => nil
    ).as_new_record)
  end

  it "renders new make form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_makes_path, :method => "post" do
      assert_select "input#make_user", :name => "make[user]"
    end
  end
end
