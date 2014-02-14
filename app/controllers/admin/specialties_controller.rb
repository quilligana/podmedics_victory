class Admin::SpecialtiesController < InheritedResources::Base
  layout 'admin_application'
  before_action :authenticate_admin
  respond_to :html, :js

  def create
    create!(notice: 'New Specialty added') { admin_specialties_path }
  end

  def update
    update!(notice: 'Specialty updated') { admin_specialties_path }
  end

  def permitted_params
    params.permit(:specialty =>[:name, :category_id] )
  end

end
