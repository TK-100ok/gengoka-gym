require 'rails_helper'

RSpec.describe Training, type: :model do
  it "有効なtrainingを作成できる" do
    training = build(:training)

    expect(training).to be_valid
  end

  it "themeがなければ無効" do
    training = build(:training, theme: nil)

    expect(training).to be_invalid
  end

  it "explanationがなければ無効" do
    training = build(:training, explanation: nil)

    expect(training).to be_invalid
  end

  it "targetがなければ無効" do
    training = build(:training, target: nil)

    expect(training).to be_invalid
  end

  it "targetがその他の場合custom_targetがなければ無効" do
    other_target = create(:target, name: "その他")

    training = build(
      :training,
      target: other_target,
      custom_target: nil
    )

    expect(training).to be_invalid
  end

  it "targetがその他以外の場合target.nameを返す" do
    target = create(:target, name: "上司")

    training = build(:training, target: target)

    expect(training.display_target).to eq("上司")
  end

  it "targetがその他の場合custom_targetを返す" do
    target = create(:target, name: "その他")

    training = build(
      :training,
      target: target,
      custom_target: "母"
    )
    expect(training.display_target).to eq("母")
  end
end
