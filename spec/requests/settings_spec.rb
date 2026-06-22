require "rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /settings" do
    it "正常に表示される" do
      get settings_path

      expect(response).to have_http_status(:success)
    end
  end
end
