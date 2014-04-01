class Admin::CoursesController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :js

  def create
    create!(notice: 'Course added') { admin_courses_path }
  end

  def update
    update!(notice: 'Course updated') { admin_courses_path }
  end

  private

    def permitted_params
      params.permit(:course => [:title, :date, :price, :event_link, :description])
    end

end
