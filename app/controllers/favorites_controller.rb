class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.favorite_trainings.ransack(params[:q])
    @trainings = @q.result
                   .includes(:target, :ai_feedback)

    @favorites = current_user.favorites
                             .includes(training: [ :target, :ai_feedback ])
                             .order(created_at: :desc)
  end

  def create
    @training = Training.find(params[:training_id])
    current_user.favorites.create!(training: @training)
  end

  def destroy
    @training = Training.find(params[:training_id])
    favorite = current_user.favorites.find_by!(training: @training)
    favorite.destroy
  end
end
