require 'spec_helper'

describe "register/arts/new" do
  before(:each) do
    assign(:register_art, stub_model(Register::Art,
      :user => nil,
      :day => nil,
      :art_effect => nil
    ).as_new_record)
  end

  it "renders new register_art form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_arts_path, "post" do
      assert_select "input#register_art_user[name=?]", "register_art[user]"
      assert_select "input#register_art_day[name=?]", "register_art[day]"
      assert_select "input#register_art_art_effect[name=?]", "register_art[art_effect]"
    end
  end
end
