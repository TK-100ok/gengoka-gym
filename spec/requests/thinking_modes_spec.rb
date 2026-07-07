require 'rails_helper'

RSpec.describe "ThinkingModes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/thinking_modes/index"
      expect(response).to have_http_status(:success)
    end
  end

end
