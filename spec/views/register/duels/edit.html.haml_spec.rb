require 'spec_helper'

describe "register/duels/edit" do
  before(:each) do
    @register_duel = assign(:register_duel, stub_model(Register::Duel,
      :user => nil
    ))
  end

  it "renders the edit register_duel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_duels_path(@register_duel), :method => "post" do
      assert_select "input#register_duel_user", :name => "register_duel[user]"
    end
  end
end
