require 'spec_helper'

describe "register/pets/new" do
  before(:each) do
    assign(:register_pet, stub_model(Register::Pet,
      :user => nil,
      :day => nil,
      :pet => nil
    ).as_new_record)
  end

  it "renders new register_pet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_pets_path, "post" do
      assert_select "input#register_pet_user[name=?]", "register_pet[user]"
      assert_select "input#register_pet_day[name=?]", "register_pet[day]"
      assert_select "input#register_pet_pet[name=?]", "register_pet[pet]"
    end
  end
end
