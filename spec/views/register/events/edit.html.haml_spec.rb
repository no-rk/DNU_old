require 'spec_helper'

describe "register/events/edit" do
  before(:each) do
    @register_event = assign(:register_event, stub_model(Register::Event,
      :user => nil,
      :day => nil,
      :event => nil
    ))
  end

  it "renders the edit register_event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_event_path(@register_event), "post" do
      assert_select "input#register_event_user[name=?]", "register_event[user]"
      assert_select "input#register_event_day[name=?]", "register_event[day]"
      assert_select "input#register_event_event[name=?]", "register_event[event]"
    end
  end
end
