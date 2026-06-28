require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/contacts/show"
      expect(response).to have_http_status(:success)
    end
  end

end
