class AchievementsController < ApplicationController

  def index
    if logged_in?
      redirect "/recent-activity"
    else
      @title = "Fitness Tracker"
      erb :landing
    end
  end

end
