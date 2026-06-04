class TrainingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @trainings = current_user.trainings
                             .includes(:target, :ai_feedback)
                             .order(created_at: :desc)
  end

  def new
    @training = Training.new
    @targets = Target.all
  end

  def create
    @training = current_user.trainings.build(training_params)

    if @training.save
      result = Openai::FeedbackGenerator.call(@training)

      # 👇 DBに保存
      AiFeedback.create!(
        training: @training,
        good_points: result["good_points"],
        improvement_points: result["improvement_points"],
        overall_comment: result["overall_comment"],
        score: result["score"]
      )
      redirect_to result_training_path(@training), notice: "トレーニングを保存しました"
    else
      @targets = Target.all
      render :new, status: :unprocessable_entity
    end
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
