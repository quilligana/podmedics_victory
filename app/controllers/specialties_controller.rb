class SpecialtiesController < ApplicationController

  def show
    @specialty = Specialty.friendly.find(params[:id]) 
  end

end
