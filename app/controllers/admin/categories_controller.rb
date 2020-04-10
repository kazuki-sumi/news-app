module Admin
  class CategoriesController < Admin::BaseController
    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "カテゴリーを作成しました"
      else
        flash.now[:danger] = "カテゴリーの作成に失敗しました"
        render :new
      end
    end

    def edit
      @category = Category.find(params[:id])
    end

    def update
      @category = Category.find(params[:id])
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "カテゴリーを編集しました"
      else
        flash.now[:danger] = "カテゴリーを編集できませんでした"
        render :edit
      end
    end

    def destroy
      @category = Category.find(params[:id])
      @category.destroy!
      redirect_to admin_categories_path, notice: "カテゴリー「#{@category.name}」を削除しました"
    end

    private

      def category_params
        params.require(:category).permit(:name)
      end
    end
end
