require 'spec_helper'

describe "register_initials/new" do
  before(:each) do
    assign(:initial, stub_model(Register::Initial,
      :user => nil
    ).as_new_record)
  end

  it "renders new initial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_initials_path, :method => "post" do
      assert_select "input#initial_user", :name => "initial[user]"
    end
  end
end
