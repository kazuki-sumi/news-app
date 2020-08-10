module UserSummaries
  class DailyUserSummaryService
    # コメントとpv数
    def execute
      date = Date.yesterday
      users = User.includes(:articles).where(role: "admin")
      daily_user_summaries = []
      users.each do |user|
        article_ids = user.articles.map(&:id)
        daily_article_summaries = DailyArticleSummary.where(date: date).where(article_id: article_ids)
        next if daily_article_summaries.blank?

        pv_count = 0
        comment_count = 0
        daily_article_summaries.each do |daily_article_summary|
          pv_count += daily_article_summary.pv_count
          comment_count += daily_article_summary.comment_count
        end
        daily_user_summaries << DailyUserSummary.new(
          user_id: user.id,
          pv_count: pv_count,
          comment_count: comment_count,
          date: date
        )
      end
      DailyUserSummary.import daily_user_summaries
    end
  end
end
