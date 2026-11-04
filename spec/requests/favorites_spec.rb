require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:turbo_stream_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  before do
    sign_in user
  end

  describe "POST /trainings/:training_id/favorite" do
    context "他ユーザーの投稿中のトレーニングの場合" do
      let(:training) { create(:training, user: other_user) }

      before do
        create(:post, user: other_user, training: training)
      end

      it "お気に入り登録できる" do
        expect {
          post training_favorite_path(training), headers: turbo_stream_headers
        }.to change(Favorite, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "自分のトレーニングの場合" do
      let(:training) { create(:training, user: user) }

      it "投稿していなくてもお気に入り登録できる" do
        expect {
          post training_favorite_path(training), headers: turbo_stream_headers
        }.to change(Favorite, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "他ユーザーの未投稿のトレーニングの場合" do
      let(:training) { create(:training, user: other_user) }

      it "お気に入り登録できない" do
        expect {
          post training_favorite_path(training), headers: turbo_stream_headers
        }.not_to change(Favorite, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "投稿が取り消されたトレーニングのお気に入り" do
    let(:training) { create(:training, user: other_user, theme: "取り消されたテーマ") }
    let!(:post_record) { create(:post, user: other_user, training: training) }

    before do
      create(:favorite, user: user, training: training)
    end

    it "投稿中はお気に入り一覧に表示される" do
      get favorites_path

      expect(response.body).to include("取り消されたテーマ")
    end

    context "投稿が取り消された場合" do
      before do
        post_record.destroy
      end

      it "お気に入り一覧に表示されない" do
        get favorites_path

        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include("取り消されたテーマ")
      end

      it "お気に入り詳細にアクセスすると404になる" do
        get favorite_path(training)

        expect(response).to have_http_status(:not_found)
      end

      it "お気に入りのデータは削除されない" do
        expect(Favorite.exists?(user: user, training: training)).to be true
      end

      it "再投稿されるとお気に入り一覧に再び表示される" do
        create(:post, user: other_user, training: training)

        get favorites_path

        expect(response.body).to include("取り消されたテーマ")
      end
    end
  end
end