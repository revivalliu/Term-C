require 'rails_helper'

RSpec.describe "servers/index", type: :view do
  before(:each) do
    assign(:servers, [
      Server.create!(
        :id => 1,
        :name => "Name",
        :region => 2,
        :url => "Url",
        :startTime => 3,
        :endTime => 4
      ),
      Server.create!(
        :id => 1,
        :name => "Name",
        :region => 2,
        :url => "Url",
        :startTime => 3,
        :endTime => 4
      )
    ])
  end

  it "renders a list of servers" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
