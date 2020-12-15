class Article < ApplicationRecord
  extend Enumerize
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  has_many :article_histories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :daily_article_summaries, dependent: :destroy
  has_many :weekly_article_summaries, dependent: :destroy
  has_many :monthly_article_summaries, dependent: :destroy
  belongs_to :category, optional: true
  belongs_to :operator
  paginates_per 10
  acts_as_paranoid
  enumerize :status, in: { draft: 0, release: 1 }, default: :draft, predicates: true, scope: true

  scope :order_created_at_desc, -> { order(created_at: :desc) }
  scope :released_articles, -> { with_status(:release).where("released_at <= ?", Time.zone.now) }

  def update_with_history!
    ActiveRecord::Base.transaction do
      save!
      ArticleHistory.create_article_history!(self)
    end
  end
end
