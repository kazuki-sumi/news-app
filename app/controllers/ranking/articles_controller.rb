module Ranking
  class ArticlesController < ApplicationController
    def index
      @form = Ranking::Articles::SearchForm.new(search_params)
      @articles = @form.search
      @categories = Category.all
    end

    private

    def search_params
      params[:path] = request.path
      params.permit(:term, :category_name, :path)
    end
  end
end
