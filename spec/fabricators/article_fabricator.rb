Fabricator(:article) do
  # user_id 1
  # category_id 1
  title "テストタイトル"
  content "テストコメント"
  slug "test"
  status 1
  released_at  Time.zone.now
  pv_count { rand(1..1000) }
end