class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Post.joins(:training).ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @posts = @q.result.includes(training: [ :target, :ai_feedback ]).page(params[:page])
  end

  def create
    training = current_user.trainings.find(params[:training_id])
    training.create_post!(user: current_user)
    redirect_back(
      fallback_location: trainings_path,
      notice: "トレーニングを投稿しました"
    )
  end

  def show
    @post = Post.includes(training: [ :target, :ai_feedback ]).find(params[:id])
    @training = @post.training
  end

  def destroy
    training = current_user.trainings.find(params[:training_id])
    training.post&.destroy
    redirect_to posts_path, notice: "投稿を取り消しました"
  end
end
