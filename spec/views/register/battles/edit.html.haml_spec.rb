require 'spec_helper'

describe "register/battles/edit" do
  before(:each) do
    @register_battle = assign(:register_battle, stub_model(Register::Battle,
      :user => nil
    ))
  end

  it "renders the edit register_battle form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_battles_path(@register_battle), :method => "post" do
      assert_select "input#register_battle_user", :name => "register_battle[user]"
    end
  end
end
