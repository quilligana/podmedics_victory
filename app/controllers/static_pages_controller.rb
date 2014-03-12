class StaticPagesController < ApplicationController

  def home
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

end
