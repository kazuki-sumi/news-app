class ArticleFile < ApplicationRecord
  validates :name, length: { in: 1..100 }, presence: true
  validates :slug, presence: true, length: { in: 1..100 }, uniqueness: true
  validates :file_url, presence: { message: "を選択してください" }
  paginates_per 10
  mount_uploader :file_url, ArticleFileUploader

  def set_file_info
    self.file_type = File.extname(file_url.identifier)
    self.file_size = file_url.size
    image = if Rails.env.production?
              MiniMagick::Image.open(file_url.url)
            else
              MiniMagick::Image.open(file_url.path)
            end
    if image.valid?
      self.data = { "width": image[:width], "height": image[:height] }
    end
  end
end
