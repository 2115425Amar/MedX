# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # This will group by hour (you can change it to :minute if you want more granularity)
    @chart_data = User.group_by_hour(:created_at, format: "%d %b %Y %I:%M %p").count
  end
end
