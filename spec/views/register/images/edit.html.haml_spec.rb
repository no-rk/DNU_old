require 'spec_helper'

describe "register/images/edit" do
  before(:each) do
    @register_image = assign(:register_image, stub_model(Register::Image,
      :user => nil
    ))
  end

  it "renders the edit register_image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_images_path(@register_image), :method => "post" do
      assert_select "input#register_image_user", :name => "register_image[user]"
    end
  end
end
