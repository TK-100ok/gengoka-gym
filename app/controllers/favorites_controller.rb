class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    training = Training.find(params[:training_id])

    current_user.favorites.create!(
      training: training
    )

    redirect_back(
      fallback_location: trainings_path,
      notice: "お気に入りに登録しました"
    )
  end

  def destroy
    favorite = current_user.favorites.find_by!(
      training_id: params[:training_id]
    )

    favorite.destroy

    redirect_back(
      fallback_location: trainings_path,
      notice: "お気に入りを解除しました"
    )
  end
end
