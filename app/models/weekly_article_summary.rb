class WeeklyArticleSummary < ApplicationRecord
  belongs_to :article

  scope :top_pv_summaries, ->(date) { includes(article: :category).where(end_date: date).order(pv_count: :desc) }
  scope :top_comment_summaries, ->(date) do
    includes(article: :category).where(end_date: date).order(comment_count: :desc)
  end
end
