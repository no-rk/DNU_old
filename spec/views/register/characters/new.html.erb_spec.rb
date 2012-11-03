require 'spec_helper'

describe "register_characters/new" do
  before(:each) do
    assign(:character, stub_model(Register::Character,
      :user => nil
    ).as_new_record)
  end

  it "renders new character form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_characters_path, :method => "post" do
      assert_select "input#character_user", :name => "character[user]"
    end
  end
end
