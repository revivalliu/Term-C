require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, Match.new(
      :id => 1,
      :sessionId => 1,
      :foodEaten => 1,
      :playersEaten => 1,
      :trapsEaten => 1,
      :highestMass => 1,
      :leaderboardTime => 1,
      :topPosition => 1
    ))
  end

  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "input#match_id[name=?]", "match[id]"

      assert_select "input#match_sessionId[name=?]", "match[sessionId]"

      assert_select "input#match_foodEaten[name=?]", "match[foodEaten]"

      assert_select "input#match_playersEaten[name=?]", "match[playersEaten]"

      assert_select "input#match_trapsEaten[name=?]", "match[trapsEaten]"

      assert_select "input#match_highestMass[name=?]", "match[highestMass]"

      assert_select "input#match_leaderboardTime[name=?]", "match[leaderboardTime]"

      assert_select "input#match_topPosition[name=?]", "match[topPosition]"
    end
  end
end
