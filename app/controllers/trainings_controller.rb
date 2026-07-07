class TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.trainings.ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @trainings = @q.result.includes(:target, :ai_feedback, :post).page(params[:page])
  end

  def new
    @training = Training.new
    @targets = Target.all
    @remaining_ai_usage = AiUsageService.remaining_count(current_user)
  end

  def create
    if AiUsageService.limit_reached?(current_user)
      redirect_back(
        fallback_location: trainings_path,
        alert: "本日のAI利用回数の上限に達しました"
      )
      return
    end

    ActiveRecord::Base.transaction do
      @training = current_user.trainings.create!(training_params)
      result = Openai::FeedbackGenerator.call(@training)
      AiFeedback.create!(
        training: @training,
        good_points: result["good_points"],
        improvement_points: result["improvement_points"],
        overall_comment: result["overall_comment"],
        score: result["score"]
      )
      AiUsageService.increment(current_user)
    end

    redirect_to result_training_path(@training), notice: "トレーニングを保存しました"

  rescue StandardError => e
    Rails.logger.error(e)

    @training ||= current_user.trainings.build(training_params)
    @targets = Target.all
    @remaining_ai_usage = AiUsageService.remaining_count(current_user)

    flash.now[:alert] = "AIフィードバックの生成に失敗しました"

    render :new, status: :unprocessable_entity
  end

  def show
    @training = current_user.trainings.find(params[:id])
  end

  def result
    @training = current_user.trainings.find(params[:id])
  end
end

private

def training_params
  params.require(:training).permit(:theme, :explanation, :target_id, :custom_target)
end
