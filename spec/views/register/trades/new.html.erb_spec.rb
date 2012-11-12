require 'spec_helper'

describe "register_trades/new" do
  before(:each) do
    assign(:trade, stub_model(Register::Trade,
      :user => nil
    ).as_new_record)
  end

  it "renders new trade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_trades_path, :method => "post" do
      assert_select "input#trade_user", :name => "trade[user]"
    end
  end
end
