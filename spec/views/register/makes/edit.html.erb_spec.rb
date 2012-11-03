require 'spec_helper'

describe "register_makes/edit" do
  before(:each) do
    @make = assign(:make, stub_model(Register::Make,
      :user => nil
    ))
  end

  it "renders the edit make form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_makes_path(@make), :method => "post" do
      assert_select "input#make_user", :name => "make[user]"
    end
  end
end
