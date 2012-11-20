require 'spec_helper'

describe "register/battles/new" do
  before(:each) do
    assign(:register_battle, stub_model(Register::Battle,
      :user => nil
    ).as_new_record)
  end

  it "renders new register_battle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_battles_path, :method => "post" do
      assert_select "input#register_battle_user", :name => "register_battle[user]"
    end
  end
end
