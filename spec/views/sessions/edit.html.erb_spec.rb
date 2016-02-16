require 'rails_helper'

RSpec.describe "sessions/edit", type: :view do
  before(:each) do
    @session = assign(:session, Session.create!(
      :id => 1,
      :name => "MyString",
      :userId => 1,
      :serverId => 1,
      :startTime => 1,
      :endTime => 1
    ))
  end

  it "renders the edit session form" do
    render

    assert_select "form[action=?][method=?]", session_path(@session), "post" do

      assert_select "input#session_id[name=?]", "session[id]"

      assert_select "input#session_name[name=?]", "session[name]"

      assert_select "input#session_userId[name=?]", "session[userId]"

      assert_select "input#session_serverId[name=?]", "session[serverId]"

      assert_select "input#session_startTime[name=?]", "session[startTime]"

      assert_select "input#session_endTime[name=?]", "session[endTime]"
    end
  end
end
