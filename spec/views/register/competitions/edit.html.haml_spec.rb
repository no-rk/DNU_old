require 'spec_helper'

describe "register/competitions/edit" do
  before(:each) do
    @register_competition = assign(:register_competition, stub_model(Register::Competition,
      :user => nil
    ))
  end

  it "renders the edit register_competition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_competitions_path(@register_competition), :method => "post" do
      assert_select "input#register_competition_user", :name => "register_competition[user]"
    end
  end
end
