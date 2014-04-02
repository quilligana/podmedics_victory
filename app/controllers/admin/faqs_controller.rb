class Admin::FaqsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :js

  def create
    create!(notice: 'FAQ added') { admin_faqs_path }
  end

  def update
    create!(notice: 'FAQ updated') { admin_faqs_path }
  end

  protected

    def permitted_params
      params.permit(:faq => [:title, :content, :member_only])
    end

end
