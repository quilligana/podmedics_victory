class Admin::SpecialtiesController < ApplicationController
  layout 'admin_application'
  respond_to :html
  before_action :find_specialty, only: [:show, :edit, :update, :destroy]

  def index
    @specialties = Specialty.includes(:category, :notes).order(:name)
  end

  def new
    @specialty = Specialty.new
  end

  def show
  end

  def edit
  end

  def create
    @specialty = Specialty.new(specialty_params)
    if @specialty.save
      redirect_to admin_specialties_path, notice: 'New Specialty added'
    else
      render :new
    end
  end

  def update
    if @specialty.update_attributes(specialty_params)
      redirect_to admin_specialties_path, notice: 'Specialty updated'
    else
      render :edit
    end
  end

  def destroy
    @specialty.destroy
    redirect_to admin_specialties_path, notice: 'Specialty removed'
  end

  private

    def specialty_params
      params.require(:specialty).permit(:name, :category_id)
    end

    def find_specialty
      @specialty = Specialty.friendly.find(params[:id])
    end

end
