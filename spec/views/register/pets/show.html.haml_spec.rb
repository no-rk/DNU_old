require 'spec_helper'

describe "register/pets/show" do
  before(:each) do
    @register_pet = assign(:register_pet, stub_model(Register::Pet,
      :user => nil,
      :day => nil,
      :pet => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
