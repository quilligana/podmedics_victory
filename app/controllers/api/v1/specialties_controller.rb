class API::V1::SpecialtiesController < ApplicationController
  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def index
    @specialties = Specialty.order(:name)
    respond_with @specialties
  end

end
