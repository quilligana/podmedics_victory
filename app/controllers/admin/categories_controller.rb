class Admin::CategoriesController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html

  def create
    create!(notice: 'New Category added') { admin_categories_path }
  end

  def update
    update!(notice: 'Category updated') { admin_categories_path }
  end

  protected

  def permitted_params
    params.permit(:category => [:name])
  end
  
end
