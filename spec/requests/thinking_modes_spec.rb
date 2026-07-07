require 'rails_helper'

RSpec.describe "ThinkingModes", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "returns http success" do
      get thinking_modes_path

      expect(response).to have_http_status(:success)
    end
  end
end
