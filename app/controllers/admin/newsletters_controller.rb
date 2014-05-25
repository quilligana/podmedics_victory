class Admin::NewslettersController < ApplicationController
  layout 'admin_application'

  def index
    @newsletters = Newsletter.all
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.save
      redirect_to admin_newsletters_path, notice: 'Newsletter created'
    else
      render 'new'
    end
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(newsletter_params)
      redirect_to admin_newsletters_path, notice: 'Newsletter updated'
    else
      render 'edit'
    end
  end

  private

    def newsletter_params
      params.require(:newsletter).permit(:subject, :body_content, :body_text)
    end
end
