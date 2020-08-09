module Admin
  module Articles
    class SearchForm
      include ActiveModel::Model
      attr_accessor :title, :status, :category_id, :min_released_at, :max_released_at

      def initialize(args = {})
        @title = args[:title]
        @status = args[:status]
        @category_id = args[:category_id]
        @min_released_at = args["min_released_at(1i)"].present? ? convert_min_released_at(args) : nil
        @max_released_at = args["max_released_at(1i)"].present? ? convert_max_released_at(args) : nil
      end

      def search(page)
        articles = Article.all
        articles = articles.where(category_id: category_id) if category_id.present?
        articles = articles.where('title LIKE ?', "%#{title}%") if title.present?
        articles = articles.where(status: status) if status.present?
        articles = articles.where('released_at >= ?', min_released_at) if min_released_at.present?
        articles = articles.where('released_at <= ?', max_released_at) if max_released_at.present?
        articles.order(created_at: :desc).page(page)
      end

      private

      def convert_min_released_at(args)
        Date.new(
          args["min_released_at(1i)"].to_i,
          args["min_released_at(2i)"].to_i,
          args["min_released_at(3i)"].to_i
        )
      end

      def convert_max_released_at(args)
        Date.new(
          args["max_released_at(1i)"].to_i,
          args["max_released_at(2i)"].to_i,
          args["max_released_at(3i)"].to_i
        )
      end
    end
  end
end
