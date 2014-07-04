class Admin::CategoriesController < ApplicationController
  layout 'admin_application'
  respond_to :html
  before_action :find_category, only: [:show, :edit, :update]

  def index
    @categories = Category.order(:name)
  end

  def show
  end

  def edit
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'New Category added'
    else
      render :new
    end
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to admin_categories_path, notice: 'Category updated'
    else
      render :edit
    end
  end

  private

    def find_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  
end
