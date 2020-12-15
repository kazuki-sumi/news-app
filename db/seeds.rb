# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
date = Time.zone.now

10.times do |t|
  User.create(
    email: "test#{t}@example.com",
    password: "password",
    password_confirmation: "password",
    role: 1
  )
end

10.times do |t|
  User.create(
    email: "sample#{t}@example.com",
    password: "password",
    password_confirmation: "password",
    role: 0
  )
end

10.times do |t|
  Operator.create(
    email: "test#{t}@example.com",
    password: "password",
    password_confirmation: "password",
    role: 1
  )
end

10.times do |t|
  Operator.create(
    email: "sample#{t}@example.com",
    password: "password",
    password_confirmation: "password",
    role: 0
  )
end

Category.create(name: "政治")
Category.create(name: "テクノロジー")
Category.create(name: "金融")
Category.create(name: "新型コロナ")
Category.create(name: "プログラミング")

20.times do |t|
  Article.create(
    operator_id: rand(1..10),
    category_id: rand(1..5),
    title: "テストタイトル#{t}",
    content: "テスト本文",
    slug: "test#{t}",
    status: 1,
    released_at: date.tomorrow,
    created_at: date,
    updated_at: date
  )
end

20.times do |t|
  Article.create(
    operator_id: rand(1..10),
    category_id: rand(1..5),
    title: "プログラムタイトル#{t}",
    content: "プログラム本文",
    slug: "program#{t}",
    status: 1,
    pv_count: rand(0..1000),
    released_at: date.prev_month(3) - 1.days,
    created_at:  date.prev_month(3),
    updated_at: date.prev_month(3)
  )
end

20.times do |t|
  Article.create(
    operator_id: rand(1..10),
    category_id: rand(1..5),
    title: "サンプルタイトル#{t}",
    content: "サンプル本文",
    slug: "sample#{t}",
    status: 0
  )
end

30.times do |time|
  comments = []
  500.times do |t|
    comment = Comment.new(
                article_id: rand(21..40),
                comment: "コメント",
                created_at:  date.prev_month(3) + time.day,
                updated_at: date.prev_month(3) + time.day
              )
    comments << comment
  end
  Comment.import comments
end

30.times do |time|
  comments = []
  500.times do |t|
    comment = Comment.new(
                article_id: rand(21..40),
                comment: "コメント",
                created_at:  date.prev_month(2) + time.day,
                updated_at: date.prev_month(2) + time.day
              )
    comments << comment
  end
  Comment.import comments
end

30.times do |time|
  comments = []
  500.times do |t|
    comment = Comment.new(
                article_id: rand(21..40),
                comment: "コメント",
                created_at:  date.prev_month(1) + time.day,
                updated_at: date.prev_month(1) + time.day
              )
    comments << comment
  end
  Comment.import comments
end

30.times do |t|
  20.times do |time|
    time += 21
    from = date.prev_month(3).beginning_of_day + (t + 1).day
    to = date.prev_month(3).end_of_day + (t + 1).day
    comments = Comment.where(article_id: time).where(created_at: from..to)
    DailyArticleSummary.create(
      article_id: time,
      pv_count: rand(1..1000),
      comment_count: comments.size,
      date: Date.today.prev_month(3) + (t + 1).day,
      created_at: date.prev_month(3) + (t + 2).day,
      updated_at: date.prev_month(3) + (t + 2).day
    )
  end
end

30.times do |t|
  20.times do |time|
    time += 21
    from = date.prev_month(3).beginning_of_day + (t + 1).day
    to = date.prev_month(3).end_of_day + (t + 1).day
    comments = Comment.where(article_id: time).where(created_at: from..to)
    DailyArticleSummary.create(
      article_id: time,
      pv_count: rand(1..1000),
      comment_count: comments.size,
      date: Date.today.prev_month(2) + (t + 1).day,
      created_at: date.prev_month(2) + (t + 2).day,
      updated_at: date.prev_month(2) + (t + 2).day
    )
  end
end

30.times do |t|
  20.times do |time|
    time += 21
    from = date.prev_month(3).beginning_of_day + (t + 1).day
    to = date.prev_month(3).end_of_day + (t + 1).day
    comments = Comment.where(article_id: time).where(created_at: from..to)
    DailyArticleSummary.create(
      article_id: time,
      pv_count: rand(1..1000),
      comment_count: comments.size,
      date: Date.today.prev_month(1) + (t + 1).day,
      created_at: date.prev_month(1) + (t + 2).day,
      updated_at: date.prev_month(1) + (t + 2).day
    )
  end
end