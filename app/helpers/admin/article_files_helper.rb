module Admin
  module ArticleFilesHelper
    def image?(article_file)
      image = if Rails.env.production?
                MiniMagick::Image.open(article_file.file_url.url)
              else
                MiniMagick::Image.open(article_file.file_url.path)
              end
      image.valid?
    end
  end
end
