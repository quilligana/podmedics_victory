class StaticPagesController < ApplicationController
  layout 'user_application', only: [:support]

  def home
    redirect_to dashboard_path if current_user
  end

  def about
  end

  def faqs
    @faqs = Faq.all
  end

  def library
    @categories = Category.includes(specialties: [:videos])
  end

  def terms
  end

  def contact
  end

  def support
    @faqs = Faq.for_members
  end

end
