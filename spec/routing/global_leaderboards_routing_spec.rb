require "rails_helper"

RSpec.describe GlobalLeaderboardsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/global_leaderboards").to route_to("global_leaderboards#index")
    end

    it "routes to #new" do
      expect(:get => "/global_leaderboards/new").to route_to("global_leaderboards#new")
    end

    it "routes to #show" do
      expect(:get => "/global_leaderboards/1").to route_to("global_leaderboards#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/global_leaderboards/1/edit").to route_to("global_leaderboards#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/global_leaderboards").to route_to("global_leaderboards#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/global_leaderboards/1").to route_to("global_leaderboards#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/global_leaderboards/1").to route_to("global_leaderboards#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/global_leaderboards/1").to route_to("global_leaderboards#destroy", :id => "1")
    end

  end
end
