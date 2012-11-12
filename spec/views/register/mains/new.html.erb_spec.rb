require 'spec_helper'

describe "register_mains/new" do
  before(:each) do
    assign(:main, stub_model(Register::Main,
      :user => nil
    ).as_new_record)
  end

  it "renders new main form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_mains_path, :method => "post" do
      assert_select "input#main_user", :name => "main[user]"
    end
  end
end
