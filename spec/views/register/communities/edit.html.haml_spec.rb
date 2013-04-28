require 'spec_helper'

describe "register/communities/edit" do
  before(:each) do
    @register_community = assign(:register_community, stub_model(Register::Community,
      :user => nil,
      :day => nil
    ))
  end

  it "renders the edit register_community form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_community_path(@register_community), "post" do
      assert_select "input#register_community_user[name=?]", "register_community[user]"
      assert_select "input#register_community_day[name=?]", "register_community[day]"
    end
  end
end
