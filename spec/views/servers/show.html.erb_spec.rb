require 'rails_helper'

RSpec.describe "servers/show", type: :view do
  before(:each) do
    @server = assign(:server, Server.create!(
      :id => 1,
      :name => "Name",
      :region => 2,
      :url => "Url",
      :startTime => 3,
      :endTime => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
