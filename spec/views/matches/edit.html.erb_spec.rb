require 'rails_helper'

RSpec.describe "matches/edit", type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
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

  it "renders the edit match form" do
    render

    assert_select "form[action=?][method=?]", match_path(@match), "post" do

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
