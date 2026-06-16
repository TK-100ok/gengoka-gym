class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
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
