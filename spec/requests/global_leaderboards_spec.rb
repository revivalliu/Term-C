require 'rails_helper'

RSpec.describe "GlobalLeaderboards", type: :request do
  describe "GET /global_leaderboards" do
    it "works! (now write some real specs)" do
      get global_leaderboards_path
      expect(response).to have_http_status(200)
    end
  end
end
