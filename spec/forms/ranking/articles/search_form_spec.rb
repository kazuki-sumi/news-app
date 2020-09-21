require 'rails_helper'

RSpec.describe Ranking::Articles::SearchForm do
  describe "#search" do
    let!(:user) { Fabricate(:user, id: 1) }
    let!(:category1) { Fabricate(:category) }
    let!(:category2) { Fabricate(:category, name: "政治") }
    let!(:article1) { Fabricate(:article, user_id: user.id, category_id: category1.id) }
    let!(:article2) { Fabricate(:article, user_id: user.id, category_id: category1.id, slug: "test2") }
    let!(:article3) { Fabricate(:article, user_id: user.id, category_id: category1.id, slug: "test3") }
    let!(:article4) { Fabricate(:article, user_id: user.id, category_id: category2.id, slug: "test4") }
    let!(:article5) { Fabricate(:article, user_id: user.id, category_id: category2.id, slug: "test5") }
    let!(:daily_article_summary1) { Fabricate(:daily_article_summary, article_id: article1.id, date: Date.yesterday - 30, pv_count: 140, comment_count: 140) }
    let!(:daily_article_summary2) { Fabricate(:daily_article_summary, article_id: article2.id, date: Date.yesterday - 30, pv_count: 150, comment_count: 150) }
    let!(:daily_article_summary3) { Fabricate(:daily_article_summary, article_id: article3.id, date: Date.yesterday - 30, pv_count: 110, comment_count: 110) }
    let!(:daily_article_summary4) { Fabricate(:daily_article_summary, article_id: article4.id, date: Date.yesterday - 30, pv_count: 120, comment_count: 120) }
    let!(:daily_article_summary5) { Fabricate(:daily_article_summary, article_id: article5.id, date: Date.yesterday - 30, pv_count: 130, comment_count: 130) }
    let!(:daily_article_summary6) { Fabricate(:daily_article_summary, article_id: article1.id, date: Date.yesterday - 7, pv_count: 140, comment_count: 140) }
    let!(:daily_article_summary7) { Fabricate(:daily_article_summary, article_id: article2.id, date: Date.yesterday - 7, pv_count: 100, comment_count: 100) }
    let!(:daily_article_summary8) { Fabricate(:daily_article_summary, article_id: article3.id, date: Date.yesterday - 7, pv_count: 110, comment_count: 110) }
    let!(:daily_article_summary9) { Fabricate(:daily_article_summary, article_id: article4.id, date: Date.yesterday - 7, pv_count: 120, comment_count: 120) }
    let!(:daily_article_summary10) { Fabricate(:daily_article_summary, article_id: article5.id, date: Date.yesterday - 7, pv_count: 130, comment_count: 130) }
    let!(:daily_article_summary11) { Fabricate(:daily_article_summary, article_id: article1.id, pv_count: 100, comment_count: 100) }
    let!(:daily_article_summary12) { Fabricate(:daily_article_summary, article_id: article2.id, pv_count: 110, comment_count: 110) }
    let!(:daily_article_summary13) { Fabricate(:daily_article_summary, article_id: article3.id, pv_count: 120, comment_count: 120) }
    let!(:daily_article_summary14) { Fabricate(:daily_article_summary, article_id: article4.id, pv_count: 130, comment_count: 130) }
    let!(:daily_article_summary15) { Fabricate(:daily_article_summary, article_id: article5.id, pv_count: 140, comment_count: 140) }

    subject { Ranking::Articles::SearchForm.new({ term: term, category_name: category_name, path: path }).search }

    context "pvランキングの場合" do
      let(:path) { "/pv" }
      context "categoryが指定されている場合" do
        let(:category_name) { "コンピュータ" }
        context "期間がdailyの場合" do
          let(:term) { "daily" }

          it { is_expected.to eq [article3, article2, article1] }
        end

        context "期間がweeklyの場合" do
          let(:term) { "weekly" }

          it { is_expected.to eq [article1, article3, article2] }
        end

        context "期間がmonthlyの場合" do
          let(:term) { "monthly" }

          it { is_expected.to eq [article1, article2, article3] }
        end
      end

      context "categoryが指定されていない場合" do
        let(:category_name) { nil }
        context "期間がdailyの場合" do
          let(:term) { "daily" }

          it { is_expected.to eq [article5, article4, article3, article2, article1] }
        end

        context "期間がweeklyの場合" do
          let(:term) { "weekly" }

          it { is_expected.to eq [article5, article4, article1, article3, article2] }
        end

        context "期間がmonthlyの場合" do
          let(:term) { "monthly" }

          it { is_expected.to eq [article5, article1, article4, article2, article3] }
        end
      end
    end

    context "コメントランキングの場合" do
      let(:path) { "/comment" }
      context "categoryが指定されている場合" do
        let(:category_name) { "コンピュータ" }
        context "期間がdailyの場合" do
          let(:term) { "daily" }

          it { is_expected.to eq [article3, article2, article1] }
        end

        context "期間がweeklyの場合" do
          let(:term) { "weekly" }

          it { is_expected.to eq [article1, article3, article2] }
        end

        context "期間がmonthlyの場合" do
          let(:term) { "monthly" }

          it { is_expected.to eq [article1, article2, article3] }
        end
      end

      context "categoryが指定されていない場合" do
        let(:category_name) { nil }
        context "期間がdailyの場合" do
          let(:term) { "daily" }

          it { is_expected.to eq [article5, article4, article3, article2, article1] }
        end

        context "期間がweeklyの場合" do
          let(:term) { "weekly" }

          it { is_expected.to eq [article5, article4, article1, article3, article2] }
        end

        context "期間がmonthlyの場合" do
          let(:term) { "monthly" }

          it { is_expected.to eq [article5, article1, article4, article2, article3] }
        end
      end
    end
  end
end
