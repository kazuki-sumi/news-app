Fabricator(:daily_article_summary) do
  # article_id 1
  pv_count { rand(1..1000) }
  comment_count { rand(1..1000) }
  date Date.yesterday
end