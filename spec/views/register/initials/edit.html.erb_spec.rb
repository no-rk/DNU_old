require 'spec_helper'

describe "register_initials/edit" do
  before(:each) do
    @initial = assign(:initial, stub_model(Register::Initial,
      :user => nil
    ))
  end

  it "renders the edit initial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_initials_path(@initial), :method => "post" do
      assert_select "input#initial_user", :name => "initial[user]"
    end
  end
end
