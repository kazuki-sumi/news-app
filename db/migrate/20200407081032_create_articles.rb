class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.references :operator, type: :bigint, foreign_key: true, null: false
      t.string :title, null: false, limit: 100
      t.string :content, null: false
      t.string :slug, null: false
      t.string :image_url
      t.timestamps
    end
    add_index :articles, :slug, :unique => true
  end
end
