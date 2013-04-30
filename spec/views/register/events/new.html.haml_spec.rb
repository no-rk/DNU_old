require 'spec_helper'

describe "register/events/new" do
  before(:each) do
    assign(:register_event, stub_model(Register::Event,
      :user => nil,
      :day => nil,
      :event => nil
    ).as_new_record)
  end

  it "renders new register_event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_events_path, "post" do
      assert_select "input#register_event_user[name=?]", "register_event[user]"
      assert_select "input#register_event_day[name=?]", "register_event[day]"
      assert_select "input#register_event_event[name=?]", "register_event[event]"
    end
  end
end
