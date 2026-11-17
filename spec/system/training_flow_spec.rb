require 'rails_helper'

RSpec.describe "トレーニングの主要な流れ", type: :system do
  let!(:user) { create(:user) }
  let!(:target) { create(:target, name: "上司") }
  let(:feedback) do
    {
      "good_points" => "結論が先に書かれていて分かりやすいです",
      "improvement_points" => "具体例を入れるとより伝わります",
      "overall_comment" => "相手を意識した説明になっています",
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

  it "ログインしてトレーニングを作成・投稿すると、みんなの投稿に表示される" do
    # ログイン
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_current_path(home_path)

    # トレーニングを作成
    visit new_training_path
    fill_in "テーマ", with: "良いリーダーとは"
    select "上司", from: "説明する相手"
    fill_in "説明内容", with: "良いリーダーとは、チームの目標を示し、メンバーが動きやすい環境を作る人です。"
    click_button "保存してフィードバックをもらう"

    # 結果画面にAIフィードバックが表示される
    expect(page).to have_content "トレーニングを保存しました"
    expect(page).to have_content "結論が先に書かれていて分かりやすいです"

    # 投稿する
    visit training_path(Training.last)
    click_button "投稿する"

    expect(page).to have_content "トレーニングを投稿しました"
    expect(page).to have_button "投稿を取り消す"

    # みんなの投稿に表示される
    visit posts_path
    expect(page).to have_content "良いリーダーとは"
  end
end
