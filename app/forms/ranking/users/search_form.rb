module Ranking
  module Users
    class SearchForm
      include ActiveModel::Model
      attr_accessor :term
      attr_accessor :path

      def initialize(args = {})
        @term = args[:term]
        @path = args[:path]
      end

      def search
        date = Date.yesterday
        model = find_term_model
        summaries = model.top_pv_summaries(date) if @path.include?("/pv")
        summaries = model.top_comment_summaries(date) if @path.include?("/comment")
        summaries.map(&:user)
      end

      private

      def find_term_model
        case @term
        when "daily"
          DailyUserSummary
        when "weekly"
          WeeklyUserSummary
        when "monthly"
          MonthlyUserSummary
        else
          DailyUserSummary
        end
      end
    end
  end
end
