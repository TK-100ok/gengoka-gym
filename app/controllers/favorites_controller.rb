class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites
                             .includes(training: [:target, :ai_feedback])
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
