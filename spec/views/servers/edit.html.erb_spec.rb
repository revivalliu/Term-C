require 'rails_helper'

RSpec.describe "servers/edit", type: :view do
  before(:each) do
    @server = assign(:server, Server.create!(
      :id => 1,
      :name => "MyString",
      :region => 1,
      :url => "MyString",
      :startTime => 1,
      :endTime => 1
    ))
  end

  it "renders the edit server form" do
    render

    assert_select "form[action=?][method=?]", server_path(@server), "post" do

      assert_select "input#server_id[name=?]", "server[id]"

      assert_select "input#server_name[name=?]", "server[name]"

      assert_select "input#server_region[name=?]", "server[region]"

      assert_select "input#server_url[name=?]", "server[url]"

      assert_select "input#server_startTime[name=?]", "server[startTime]"

      assert_select "input#server_endTime[name=?]", "server[endTime]"
    end
  end
end
