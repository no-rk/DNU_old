require 'spec_helper'

describe "register/pets/index" do
  before(:each) do
    assign(:register_pets, [
      stub_model(Register::Pet,
        :user => nil,
        :day => nil,
        :pet => nil
      ),
      stub_model(Register::Pet,
        :user => nil,
        :day => nil,
        :pet => nil
      )
    ])
  end

  it "renders a list of register/pets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
