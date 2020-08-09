module Articles
  class SearchForm
    include ActiveModel::Model
    attr_accessor :title, :category_id

    def initialize(args = {})
      @title = args[:title]
      @category_id = args[:category_id]
    end

    def search(page)
      articles = Article.includes(:category).released_articles
      articles = articles.where(category_id: category_id) if category_id.present?
      articles = articles.where('title LIKE ?', "%#{title}%") if title.present?
      articles.order(created_at: :desc).page(page)
    end
  end
end
