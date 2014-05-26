class Admin::NewslettersController < ApplicationController
  layout 'admin_application'
  before_action :find_newsletter, only: [:show, :edit, :update, :destroy]

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
  end

  def edit
  end

  def update
    if @newsletter.update_attributes(newsletter_params)
      redirect_to admin_newsletters_path, notice: 'Newsletter updated'
    else
      render 'edit'
    end
  end

  def destroy
    @newsletter.destroy
    redirect_to admin_newsletters_path, notice: 'Newsletter removed'
  end

  private

    def find_newsletter
      @newsletter = Newsletter.find(params[:id])
    end

    def newsletter_params
      params.require(:newsletter).permit(:subject, :body_content, :body_text)
    end
end
