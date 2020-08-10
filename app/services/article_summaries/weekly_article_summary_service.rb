module ArticleSummaries
  class WeeklyArticleSummaryService
    # 記事毎のpv数とコメント数を週間で集計する
    def execute
      date = Time.zone.today
      article_ids = DailyArticleSummary.where(date: date.ago(7.days)..date.yesterday).distinct.pluck(:article_id)
      total_comments = DailyArticleSummary.where(date: date.ago(7.days)..date.yesterday).
                       group(:article_id).sum(:comment_count)
      total_pvs = DailyArticleSummary.where(date: date.ago(7.days)..date.yesterday).group(:article_id).sum(:pv_count)
      weekly_article_summaries = []
      article_ids.each do |article_id|
        weekly_article_summaries << WeeklyArticleSummary.new(
          article_id: article_id,
          pv_count: total_pvs[article_id],
          comment_count: total_comments[article_id],
          start_date: date.ago(7.days),
          end_date: date.yesterday
        )
      end
      WeeklyArticleSummary.import weekly_article_summaries
    end
  end
end
