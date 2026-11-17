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
    let(:valid_params) do
      {
        training: {
          theme: "面接",
          explanation: "これは面接の説明です",
          target_id: target.id
        }
      }
    end
    let(:feedback) do
      {
        "good_points" => "結論から話せています",
        "improvement_points" => "具体例を入れるとより伝わります",
        "overall_comment" => "分かりやすい説明です",
        "score" => 80
      }
    end

    before do
      # 本物のOpenAI APIとRedisを使わないように置き換える
      allow(Openai::FeedbackGenerator).to receive(:call).and_return(feedback)
      allow(AiUsageService).to receive(:limit_reached?).and_return(false)
      allow(AiUsageService).to receive(:increment)
      allow(AiUsageService).to receive(:remaining_count).and_return(3)
    end

    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "トレーニングとAIフィードバックを作成できる" do
        expect {
          post trainings_path, params: valid_params
        }.to change(Training, :count).by(1)
          .and change(AiFeedback, :count).by(1)

        expect(response).to redirect_to(result_training_path(Training.last))
        expect(AiUsageService).to have_received(:increment).with(user)
      end
    end

    context "AIフィードバックの生成に失敗した場合" do
      before do
        sign_in user
        allow(Openai::FeedbackGenerator).to receive(:call).and_raise(StandardError)
      end

      it "トレーニングは保存されず、利用回数も増えない" do
        expect {
          post trainings_path, params: valid_params
        }.not_to change(Training, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(AiUsageService).not_to have_received(:increment)
      end
    end

    context "AI利用回数の上限に達している場合" do
      before do
        sign_in user
        allow(AiUsageService).to receive(:limit_reached?).and_return(true)
      end

      it "トレーニングは作成されず、AIも呼ばれない" do
        expect {
          post trainings_path, params: valid_params
        }.not_to change(Training, :count)

        expect(response).to redirect_to(trainings_path)
        expect(Openai::FeedbackGenerator).not_to have_received(:call)
      end
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトされる" do
        post trainings_path, params: valid_params

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
            training: { theme: nil, explanation: nil, target_id: nil }
          }
        }.not_to change(Training, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "トレーニングの詳細・結果ページ" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:own_training) { create(:training, user: user) }
    let(:other_training) { create(:training, user: other_user) }

    before do
      sign_in user
      AiFeedback.create!(training: own_training, good_points: "良い点", improvement_points: "改善点", overall_comment: "総評", score: 80)
    end

    it "自分のトレーニングの詳細ページは表示される" do
      get training_path(own_training)

      expect(response).to have_http_status(:ok)
    end

    it "他のユーザーのトレーニングの詳細ページは404になる" do
      get training_path(other_training)

      expect(response).to have_http_status(:not_found)
    end

    it "他のユーザーのトレーニングの結果ページは404になる" do
      get result_training_path(other_training)

      expect(response).to have_http_status(:not_found)
    end
  end
end