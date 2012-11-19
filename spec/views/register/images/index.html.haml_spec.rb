require 'spec_helper'

describe "register/images/index" do
  before(:each) do
    assign(:register_images, [
      stub_model(Register::Image,
        :user => nil
      ),
      stub_model(Register::Image,
        :user => nil
      )
    ])
  end

  it "renders a list of register/images" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
