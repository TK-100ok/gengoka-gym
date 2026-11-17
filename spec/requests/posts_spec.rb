require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST /trainings/:training_id/post" do
    it "自分のトレーニングを投稿できる" do
      training = create(:training, user: user)

      expect {
        post training_post_path(training)
      }.to change(Post, :count).by(1)
    end

    it "他のユーザーのトレーニングは投稿できず、404になる" do
      training = create(:training, user: other_user)

      expect {
        post training_post_path(training)
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /trainings/:training_id/post" do
    it "他のユーザーの投稿は取り消せず、404になる" do
      training = create(:training, user: other_user)
      create(:post, user: other_user, training: training)

      expect {
        delete training_post_path(training)
      }.not_to change(Post, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
