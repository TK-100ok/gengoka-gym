class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(training: [ :target, :ai_feedback ])
                 .order(created_at: :desc)
  end

  def create
    training = current_user.trainings.find(params[:training_id])

    training.create_post!(user: current_user)

    redirect_back(
      fallback_location: trainings_path,
      notice: "トレーニングを投稿しました"
    )
  end
end
