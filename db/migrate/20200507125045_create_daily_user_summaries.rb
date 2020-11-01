class CreateDailyUserSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_user_summaries do |t|
      t.references :operator, type: :bigint, null: false
      t.integer :pv_count, null: false, default: 0
      t.integer :comment_count, null: false, default: 0
      t.date :date, null: false
      t.timestamps
    end
  end
end
