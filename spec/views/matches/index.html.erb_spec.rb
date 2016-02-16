require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :id => 1,
        :sessionId => 2,
        :foodEaten => 3,
        :playersEaten => 4,
        :trapsEaten => 5,
        :highestMass => 6,
        :leaderboardTime => 7,
        :topPosition => 8
      ),
      Match.create!(
        :id => 1,
        :sessionId => 2,
        :foodEaten => 3,
        :playersEaten => 4,
        :trapsEaten => 5,
        :highestMass => 6,
        :leaderboardTime => 7,
        :topPosition => 8
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
  end
end
