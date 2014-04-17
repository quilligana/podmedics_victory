class Admin::AuthorsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html

  def create
    create!(notice: 'New Author added') { admin_authors_path }
  end

  protected

    def permitted_params
      params.permit(:author => [:name, :tagline, :twitter, :facebook, :avatar])
    end

end
