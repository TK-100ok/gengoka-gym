require 'rails_helper'

RSpec.describe "Trainings", type: :request do
  describe "GET /trainings" do
    let(:user) { create(:user) }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "正常に表示される" do
        get trainings_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトされる" do
        get trainings_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /trainings" do
    let(:user) { create(:user) }
    let(:target) { create(:target) }

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "トレーニングを作成できる" do
        expect {
          post trainings_path, params: {
            training: {
              theme: "面接",
              explanation: "これは面接の説明です",
              target_id: target.id
            }
          }
        }.to change(Training, :count).by(1)

        expect(response).to redirect_to(result_training_path(Training.last))
      end
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトされる" do
        post trainings_path, params: {
          training: {
          theme: "面接",
          explanation: "これは面接の説明です",
          target_id: target.id
          }
        }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "入力が不正な場合" do
      before do
        sign_in user
      end

      it "トレーニング作成に失敗する" do
        expect {
          post trainings_path, params: {
            training: {
              theme: nil,
              explanation: nil,
              target_id: nil
            }
          }
        }.not_to change(Training, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
