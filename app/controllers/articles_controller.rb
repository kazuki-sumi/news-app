class ArticlesController < ApplicationController
  def index
    @form = Admin::Articles::SearchForm.new(search_params)
    articles = Article.includes(:category).released_articles
    @articles = @form.search(articles, params[:page])
  end

  def show
    @article = Article.find(params[:article_id])
  end

  private

  def search_params
    params.fetch(:admin_articles_search_form, {}).permit(:title, :category_id)
  end
end
