require 'rails_helper'

RSpec.describe "sessions/new", type: :view do
  before(:each) do
    assign(:session, Session.new(
      :id => 1,
      :name => "MyString",
      :userId => 1,
      :serverId => 1,
      :startTime => 1,
      :endTime => 1
    ))
  end

  it "renders new session form" do
    render

    assert_select "form[action=?][method=?]", sessions_path, "post" do

      assert_select "input#session_id[name=?]", "session[id]"

      assert_select "input#session_name[name=?]", "session[name]"

      assert_select "input#session_userId[name=?]", "session[userId]"

      assert_select "input#session_serverId[name=?]", "session[serverId]"

      assert_select "input#session_startTime[name=?]", "session[startTime]"

      assert_select "input#session_endTime[name=?]", "session[endTime]"
    end
  end
end
