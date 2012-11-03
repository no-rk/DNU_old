require 'spec_helper'

describe "register_characters/edit" do
  before(:each) do
    @character = assign(:character, stub_model(Register::Character,
      :user => nil
    ))
  end

  it "renders the edit character form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_characters_path(@character), :method => "post" do
      assert_select "input#character_user", :name => "character[user]"
    end
  end
end
