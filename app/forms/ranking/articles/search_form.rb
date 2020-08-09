module Ranking
  module Articles
    class SearchForm
      include ActiveModel::Model
      attr_accessor :term
      attr_accessor :category_name
      attr_accessor :path

      def initialize(args = {})
        @term = args[:term]
        @category = args[:category_name]
        @path = args[:path]
      end

      def search
        date = Date.yesterday
        model = find_term_model
        category = Category.find_by(name: @category)
        if category.present?
          summaries = model.top_pv_summaries(date) if @path.include?("/pv")
          summaries = model.top_comment_summaries(date) if @path.include?("/comment")
          articles = []
          summaries.each { |summary| articles.push(summary.article) if summary.article.category_id == category.id }
          articles.take(10)
        else
          summaries = model.top_pv_summaries(date).limit(10) if @path.include?("/pv")
          summaries = model.top_comment_summaries(date).limit(10) if @path.include?("/comment")
          summaries.map(&:article)
        end
      end

      private

      def find_term_model
        case @term
        when "daily"
          DailyArticleSummary
        when "weekly"
          WeeklyArticleSummary
        when "monthly"
          MonthlyArticleSummary
        else
          DailyArticleSummary
        end
      end
    end
  end
end
