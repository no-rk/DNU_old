require 'spec_helper'

describe "register/duels/new" do
  before(:each) do
    assign(:register_duel, stub_model(Register::Duel,
      :user => nil
    ).as_new_record)
  end

  it "renders new register_duel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_duels_path, :method => "post" do
      assert_select "input#register_duel_user", :name => "register_duel[user]"
    end
  end
end
