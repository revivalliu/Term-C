require 'rails_helper'

RSpec.describe "sessions/index", type: :view do
  before(:each) do
    assign(:sessions, [
      Session.create!(
        :id => 1,
        :name => "Name",
        :userId => 2,
        :serverId => 3,
        :startTime => 4,
        :endTime => 5
      ),
      Session.create!(
        :id => 1,
        :name => "Name",
        :userId => 2,
        :serverId => 3,
        :startTime => 4,
        :endTime => 5
      )
    ])
  end

  it "renders a list of sessions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
