class CoursesController < ApplicationController
  layout 'user_application'

  def index
    @courses = Course.all
  end

end
