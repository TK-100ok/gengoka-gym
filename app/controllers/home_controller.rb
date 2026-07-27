class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @remaining_ai_usage = AiUsageService.remaining_count(current_user)
    @today_trainings_count = current_user.trainings.where(created_at: Time.zone.today.all_day).count
  end
end
