class DeleteRecords < ActiveRecord::Migration[6.0]
  def change
    drop_table :monthly_article_summaries
    drop_table :weekly_article_summaries
  end
end
