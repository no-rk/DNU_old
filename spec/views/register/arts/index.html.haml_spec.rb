require 'spec_helper'

describe "register/arts/index" do
  before(:each) do
    assign(:register_arts, [
      stub_model(Register::Art,
        :user => nil,
        :day => nil,
        :art_effect => nil
      ),
      stub_model(Register::Art,
        :user => nil,
        :day => nil,
        :art_effect => nil
      )
    ])
  end

  it "renders a list of register/arts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
