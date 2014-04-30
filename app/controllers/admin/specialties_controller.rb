class Admin::SpecialtiesController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html

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

  protected

    def collection
      @specialties ||= end_of_association_chain.includes(:videos, :questions, :user_questions).order(:name)
    end

  private

    def set_specialty
      @specialty = Specialty.cached_friendly_find(params[:id])
    end

end
