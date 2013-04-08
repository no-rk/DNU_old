require 'spec_helper'

describe "register/abilities/edit" do
  before(:each) do
    @register_ability = assign(:register_ability, stub_model(Register::Ability,
      :user => nil,
      :day => nil
    ))
  end

  it "renders the edit register_ability form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_abilities_path(@register_ability), :method => "post" do
      assert_select "input#register_ability_user", :name => "register_ability[user]"
      assert_select "input#register_ability_day", :name => "register_ability[day]"
    end
  end
end
