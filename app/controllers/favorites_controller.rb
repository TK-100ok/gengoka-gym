class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    @training = Training.find(params[:training_id])
    current_user.favorites.create!(training: @training)
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    @training = favorite.training
    favorite.destroy
  end
end
