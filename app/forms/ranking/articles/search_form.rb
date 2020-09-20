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
        date_to = Date.yesterday
        date_from = start_day
        category = Category.find_by(name: @category)
        summaries = if @path.include?("/pv")
                      DailyArticleSummary.includes(:article).where(date: date_from..date_to).group(:article_id).
                        select(:article_id, "sum(pv_count) as pv_count")
                    elsif @path.include?("/comment")
                      DailyArticleSummary.includes(:article).where(date: date_from..date_to).group(:article_id).
                        select(:article_id, "sum(comment_count) as comment_count")
                    end
        summaries = summaries.sort { |a, b| b.pv_count <=> a.pv_count }
        articles = if category.present?
                     summaries.select { |summary| summary if summary.article.category_id == category.id }
                   else
                     summaries.map(&:article)
                   end
        articles.take(10)
      end

      private

      def start_day
        case @term
        when "daily"
          Date.yesterday
        when "weekly"
          Date.yesterday.prev_day(7)
        when "monthly"
          Date.yesterday.prev_day(30)
        else
          Date.yesterday
        end
      end
    end
  end
end
