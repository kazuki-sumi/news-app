class CreateArticleFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :article_files do |t|
      t.string :name, null: false, limit: 100
      t.string :slug, null: false, limit: 100
      t.string :file_url, null: false
      t.timestamps
    end
    add_index :article_files, :slug, :unique => true
  end
end
