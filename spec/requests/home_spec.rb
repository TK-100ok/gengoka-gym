require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    let(:user) { create(:user) }

    context "ログイン済みの場合" do
      before do
        allow(AiUsageService).to receive(:remaining_count).and_return(3)
        sign_in user
      end

      it "正常に表示される" do
        get home_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "未ログインの場合" do
      it "ログインページへリダイレクトされる" do
        get home_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
