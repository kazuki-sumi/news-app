module Ranking
  class UsersController < ApplicationController
    def index
      @form = Ranking::Users::SearchForm.new(search_params)
      @users = @form.search
    end

    private

    def search_params
      params[:path] = request.path
      params.permit(:term, :path)
    end
  end
end
