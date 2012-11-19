require 'spec_helper'

describe "register/images/new" do
  before(:each) do
    assign(:register_image, stub_model(Register::Image,
      :user => nil
    ).as_new_record)
  end

  it "renders new register_image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_images_path, :method => "post" do
      assert_select "input#register_image_user", :name => "register_image[user]"
    end
  end
end
