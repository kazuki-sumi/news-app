module Admin
  class ArticlesController < Admin::BaseController
    def index
      @form = Admin::Articles::SearchForm.new(search_params)
      @articles = @form.search(params[:page])
    end

    def show
      @article = Article.find(params[:id])
    end

    def new
      @article = Article.new
    end

    def create
      @article = current_user.articles.build(article_params)
      if @article.save
        redirect_to admin_articles_path, notice: "記事を作成しました"
      else
        render :new
      end
    end

    def edit
      @article = current_user.articles.find(params[:id])
    end

    def update
      @article = current_user.articles.find(params[:id])
      @article.attributes = article_params
      if @article.update_with_history!
        redirect_to admin_articles_path, notice: "記事を更新しました"
      else
        render :edit
      end
    end

    def destroy
      @article = Article.find(params[:id])
      raise ActiveRecord::RecordNotFound unless @article.user_id == current_user.id

      if @article.destroy
        redirect_to admin_articles_path, notice: "記事を削除しました"
      else
        flash.now[:danger] = "記事の削除に失敗しました"
        render :edit
      end
    end

    private

      def article_params
        params.require(:article).permit(:title, :content, :slug, :image_url, :category_id, :status, :released_at)
      end

      def search_params
        params.fetch(:admin_articles_search_form, {}).permit(
          :status, :title, :category_id, :max_released_at, :min_released_at
        )
      end
  end
end
