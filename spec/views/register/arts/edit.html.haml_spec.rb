require 'spec_helper'

describe "register/arts/edit" do
  before(:each) do
    @register_art = assign(:register_art, stub_model(Register::Art,
      :user => nil,
      :day => nil,
      :art_effect => nil
    ))
  end

  it "renders the edit register_art form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_art_path(@register_art), "post" do
      assert_select "input#register_art_user[name=?]", "register_art[user]"
      assert_select "input#register_art_day[name=?]", "register_art[day]"
      assert_select "input#register_art_art_effect[name=?]", "register_art[art_effect]"
    end
  end
end
