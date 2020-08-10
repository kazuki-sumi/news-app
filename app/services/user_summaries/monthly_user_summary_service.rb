module UserSummaries
  class MonthlyUserSummaryService
    def execute
      date = Time.zone.today
      from = date.ago(30.days)
      to = date.yesterday
      users = User.where(role: "admin")
      monthly_user_summaries = []
      users.each do |user|
        daily_user_summaries = DailyUserSummary.where(date: from..to).where(user_id: user)
        next if daily_user_summaries.blank?

        pv_count = 0
        comment_count = 0
        daily_user_summaries.each do |daily_user_summary|
          pv_count += daily_user_summary.pv_count
          comment_count += daily_user_summary.comment_count
        end
        monthly_user_summaries << MonthlyUserSummary.new(
          user_id: user.id,
          pv_count: pv_count,
          comment_count: comment_count,
          start_date: from,
          end_date: to
        )
      end
      MonthlyUserSummary.import monthly_user_summaries
    end
  end
end
