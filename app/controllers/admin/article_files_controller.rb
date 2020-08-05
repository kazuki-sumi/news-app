module Admin
  class ArticleFilesController < Admin::BaseController
    def index
      @form = Admin::ArticleFiles::SearchForm.new(search_params)
      @article_files = @form.search(params[:page])
    end

    def show
      @article_file = ArticleFile.find(params[:id])
    end

    def new
      @article_file = ArticleFile.new
    end

    def create
      @article_file = ArticleFile.new(article_file_params)
      @article_file.set_file_info if params[:article_file][:file_url]
      if @article_file.save
        redirect_to admin_article_files_path, notice: "アップロードしました。"
      else
        render :new
      end
    end

    def edit
      @article_file = ArticleFile.find(params[:id])
    end

    def update
      @article_file = ArticleFile.find(params[:id])
      @article_file.attributes = article_file_params
      if @article_file.save
        redirect_to admin_article_file_path(@article_file), notice: "再アップロードしました"
      else
        render :edit
      end
    end

    def destroy
      @article_file = ArticleFile.find(params[:id])
      @article_file.destroy!
      redirect_to admin_article_files_path, notice: "ファイルを削除しました"
    end

    private

    def article_file_params
      params.require(:article_file).permit(:name, :slug, :file_url)
    end

    def search_params
      params.fetch(:admin_article_files_search_form, {}).permit(:name, :file_type, :min_file_size, :max_file_size)
    end
  end
end
