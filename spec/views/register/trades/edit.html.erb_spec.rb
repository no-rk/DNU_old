require 'spec_helper'

describe "register_trades/edit" do
  before(:each) do
    @trade = assign(:trade, stub_model(Register::Trade,
      :user => nil
    ))
  end

  it "renders the edit trade form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => register_trades_path(@trade), :method => "post" do
      assert_select "input#trade_user", :name => "trade[user]"
    end
  end
end
