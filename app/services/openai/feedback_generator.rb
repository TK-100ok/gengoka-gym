module Openai
  class FeedbackGenerator
    def self.call(training)
      new(training).call
    end

    def initialize(training)
      @training = training
    end

    def call
      "フィードバック生成（仮）"
    end

    private

    attr_reader :training
  end
end
