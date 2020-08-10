module ArticleSummaries
  class DailyArticleSummaryService
    # 記事毎のpv数とコメント数を日別で集計する
    def execute
      date = Date.yesterday
      from = date.beginning_of_day
      to = date.end_of_day
      articles = Article.where(status: "release").where('released_at <= ?', to).
                 or(Article.where(status: "draft").where('released_at <= ?', to))
      summaries = []
      articles.each do |article|
        summary = article.daily_article_summaries.build
        comments = article.comments.where(created_at: from..to)
        summary.pv_count = article.pv_count
        summary.comment_count = comments.size
        summary.date = date
        summaries << summary
      end
      ActiveRecord::Base.transaction do
        DailyArticleSummary.import summaries
        articles.update!(pv_count: 0)
      end
    end
  end
end
