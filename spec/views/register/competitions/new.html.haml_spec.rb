require 'spec_helper'

describe "register/competitions/new" do
  before(:each) do
    assign(:register_competition, stub_model(Register::Competition,
      :user => nil
    ).as_new_record)
  end

  it "renders new register_competition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_competitions_path, :method => "post" do
      assert_select "input#register_competition_user", :name => "register_competition[user]"
    end
  end
end
