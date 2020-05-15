namespace :user_summary do
  desc "日別、週間、月間のpv数とコメント数をユーザ毎で集計"
  task :summary do
    daily_summary = UserSummaries::DailyUserSummaryService.new
    daily_summary.execute
    weekly_summary = UserSummaries::WeeklyUserSummaryService.new
    weekly_summary.execute
    monthly_summary = UserSummaries::MonthlyUserSummaryService.new
    monthly_summary.execute
  end
end