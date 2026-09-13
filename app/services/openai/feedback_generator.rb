module Openai
  class FeedbackGenerator
    def self.call(training)
      new(training).call
    end

    def initialize(training)
      @training = training
    end

    def call
      client = OpenAI::Client.new

      response = client.chat(
        parameters: {
          model: "gpt-4.1-mini",
          messages: messages,
          response_format: { type: "json_object" },
          temperature: 0.5
        }
      )

      raw = response.dig("choices", 0, "message", "content")
      JSON.parse(raw)
    end

    private

    attr_reader :training

    def messages
      [
        {
          role: "system",
          content: "あなたは優秀な言語化トレーナーです。ユーザーの説明に対して、分かりやすく具体的にフィードバックしてください。"
        },
        {
          role: "user",
          content: build_prompt
        }
      ]
    end

    def build_prompt
      <<~TEXT
      以下の説明に対してフィードバックをしてください。

      必ず以下のJSON形式で返してください。

      {
        "good_points": "良い点",
        "improvement_points": "改善点",
        "overall_comment": "総評",
        "score": 0〜100の整数
      }

      テーマ: #{training.theme}
      相手: #{training.display_target}
      説明: #{training.explanation}

      scoreは、以下の4つの評価項目で採点してください。

      【評価項目】
      1. 分かりやすさ：
        - 相手が内容を理解しやすいか
        - 専門用語を使う場合、その意味が伝わるように説明できているか

      2. 構成・論理性：
        - 説明の順序が適切か
        - 結論や要点が分かりやすいか
        - 話のつながりに飛躍がないか

      3. 相手への適合度：
        - 指定された説明相手の知識レベルや立場に合った説明になっているか
        - 相手に不要な専門用語や情報を過剰に含めていないか

      4. 具体性：
        - 抽象的な説明だけでなく、具体例や具体的な説明が含まれているか
        - 相手が実際の内容をイメージできるか

      【採点ルール】
      - scoreは、必ず1点単位で細かく分析して採点してください。
      - 各項目について、なぜその点数になったのかを説明できる状態で採点してください。
      - 80点などのキリの良い点数に寄せる必要はありません。
      - 似た品質の回答でも、内容の具体的な違いを考慮して1〜2点程度の差をつけてください。
      - 逆に、明確な差がある場合は5点以上の差をつけてください。

      【評価の目安（合計点）】
      90〜100：非常に分かりやすい
      75〜89：概ね良い
      50〜74：改善余地あり
      21〜49：分かりにくい
      1〜20：説明として成立していない部分が多い
      TEXT
    end
  end
end
