class StaticPagesController < ApplicationController
  layout :conditional_layout, only: [:support, :about, :terms, :contact]

  def home
    redirect_to dashboard_path if current_user
  end

  def about
  end

  def faqs
    @faqs = Faq.public
  end

  def library
    @categories = Category.order(:id).select(:name, :id, :updated_at)
  end

  def terms
  end

  def contact
  end

  def support
    @faqs = Faq.all
    render :faqs
  end

  def press
  end

  def app
  end

  private

    def conditional_layout
      current_user ? 'user_application' : 'application'
    end

end
