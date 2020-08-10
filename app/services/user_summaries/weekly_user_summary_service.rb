module UserSummaries
  class WeeklyUserSummaryService
    def execute
      date = Time.zone.today
      from = date.ago(7.days)
      to = date.yesterday
      users = User.where(role: "admin")
      weekly_user_summary = []
      users.each do |user|
        daily_user_summaries = DailyUserSummary.where(date: from..to).where(user_id: user)
        next if daily_user_summaries.blank?

        pv_count = 0
        comment_count = 0
        daily_user_summaries.each do |daily_user_summary|
          pv_count += daily_user_summary.pv_count
          comment_count += daily_user_summary.comment_count
        end
        weekly_user_summary << WeeklyUserSummary.new(
          user_id: user.id,
          pv_count: pv_count,
          comment_count: comment_count,
          start_date: from,
          end_date: to
        )
      end
      WeeklyUserSummary.import weekly_user_summary
    end
  end
end
