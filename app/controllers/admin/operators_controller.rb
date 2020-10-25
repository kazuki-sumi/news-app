class Admin::OperatorsController < Admin::BaseController
  before_action :authorize_admin_user

  def index
    @operators = Operator.with_role(:admin)
  end

  def show
    @operator = Operator.with_role(:admin).find(params[:id])
  end

  def new
    @operator = Operator.new
  end

  def create
    @operator = Operator.new(operator_params)
    if @operator.save
      redirect_to admin_operators_path, notice: "ユーザを登録しました"
    else
      render :new
    end
  end

  def edit
    @operator = Operator.with_role(:admin).find(params[:id])
  end

  def update
    @operator = Operator.with_role(:admin).find(params[:id])
    if @operator.update(operator_params)
      redirect_to admin_path(@operator), notice: "ユーザの情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @operator = Operator.with_role(:admin).find(params[:id])
    @operator.destroy!
    redirect_to admin_operators_path, notice: "ユーザの情報を削除しました"
  end

  private

  def operator_params
    params.require(:operator).permit(:email, :password, :password_confirmation, :role)
  end
end
