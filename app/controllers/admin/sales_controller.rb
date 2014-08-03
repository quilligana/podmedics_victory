class Admin::SalesController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html

  protected

    def collection
      @sales ||= end_of_association_chain.includes(:product, :user).order(id: :desc)
    end

end
