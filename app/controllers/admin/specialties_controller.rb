class Admin::SpecialtiesController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :js

  before_action :set_specialty, only: [:show, :edit, :update, :destroy]

  def create
    create!(notice: 'New Specialty added') { admin_specialties_path }
  end

  def update
    update!(notice: 'Specialty updated') { admin_specialties_path }
  end

  def permitted_params
    params.permit(:specialty =>[:name, :category_id] )
  end

  private

    def set_specialty
      @specialty = Specialty.friendly.find(params[:id])
    end

end
