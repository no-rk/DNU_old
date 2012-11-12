require 'spec_helper'

describe "register_mains/edit" do
  before(:each) do
    @main = assign(:main, stub_model(Register::Main,
      :user => nil
    ))
  end

  it "renders the edit main form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_mains_path(@main), :method => "post" do
      assert_select "input#main_user", :name => "main[user]"
    end
  end
end
