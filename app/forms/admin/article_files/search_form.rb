module Admin
  module ArticleFiles
    class SearchForm
      include ActiveModel::Model
      attr_accessor :name, :file_type, :min_file_size, :max_file_size

      IMAGE_FILE = [".jpg", ".jpeg", ".gif", ".png", ".bmp", ".ico"].freeze

      def initialize(args = {})
        @name = args[:name]
        @file_type = args[:file_type]
        @min_file_size = args[:min_file_size]
        @max_file_size = args[:max_file_size]
      end

      def search(page)
        article_files = ArticleFile.all
        article_files = article_files.where('name LIKE ?', "%#{name}%") if name.present?
        if file_type.present?
          article_files = article_files.where(file_type: IMAGE_FILE) if file_type == "image"
          article_files = article_files.where(file_type: ".pdf") if file_type == "pdf"
          article_files = article_files.where(file_type: ".mp3") if file_type == "sound"
        end
        article_files = article_files.where('file_size >= ?', min_file_size.to_f * 1000) if min_file_size.present?
        article_files = article_files.where('file_size <= ?', max_file_size.to_f * 1000) if max_file_size.present?
        article_files.order(created_at: :desc).page(page)
      end
    end
  end
end
