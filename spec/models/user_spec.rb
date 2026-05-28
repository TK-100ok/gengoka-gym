require 'rails_helper'

RSpec.describe User, type: :model do
  it "nameがあれば有効" do
    user = build(:user)

    expect(user).to be_valid
  end

  it "nameがなければ無効" do
    user = build(:user, name: nil)

    expect(user).to be_invalid
  end

  it "emailがなければ無効" do
    user = build(:user, email: nil)

    expect(user).to be_invalid
  end

  it "passwordがなければ無効" do
    user = build(:user, password: nil)

    expect(user).to be_invalid
  end

  it "重複したemailは無効" do
    create(:user, email: "test@example.com")

    user = build(:user, email: "test@example.com")

    expect(user).to be_invalid
  end
end
