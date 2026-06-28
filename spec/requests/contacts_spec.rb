require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "returns http success" do
    get contact_path
    expect(response).to have_http_status(:success)
  end
end
