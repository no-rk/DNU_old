require 'spec_helper'

describe "register/pets/edit" do
  before(:each) do
    @register_pet = assign(:register_pet, stub_model(Register::Pet,
      :user => nil,
      :day => nil,
      :pet => nil
    ))
  end

  it "renders the edit register_pet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_pet_path(@register_pet), "post" do
      assert_select "input#register_pet_user[name=?]", "register_pet[user]"
      assert_select "input#register_pet_day[name=?]", "register_pet[day]"
      assert_select "input#register_pet_pet[name=?]", "register_pet[pet]"
    end
  end
end
