module ArticleSummaries
  class MonthlyArticleSummaryService
    # 記事毎のpv数とコメント数を月間で集計する
    def execute
      date = Time.zone.today
      article_ids = DailyArticleSummary.where(date: date.ago(1.month)..date.yesterday).distinct.pluck(:article_id)
      total_comments = DailyArticleSummary.where(date: date.ago(1.month)..date.yesterday).
                       group(:article_id).sum(:comment_count)
      total_pvs = DailyArticleSummary.where(date: date.ago(1.month)..date.yesterday).group(:article_id).sum(:pv_count)
      monthly_article_summaries = []
      article_ids.each do |article_id|
        monthly_article_summaries << MonthlyArticleSummary.new(
          article_id: article_id,
          pv_count: total_pvs[article_id],
          comment_count: total_comments[article_id],
          start_date: date.ago(1.month),
          end_date: date.yesterday
        )
      end
      MonthlyArticleSummary.import monthly_article_summaries
    end
  end
end
