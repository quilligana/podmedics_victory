class API::V1::SpecialtiesController < ApplicationController
  respond_to :json

  def index
    @specialties = Specialty.all
    respond_with @specialties
  end

end
