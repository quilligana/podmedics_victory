class Admin::FaqsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :js

  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  def index
    @faqs = Faq.all
  end

  def show
  end

  def new
    @faq = Faq.new
  end

  def edit
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to admin_faqs_path, notice: 'Faq created'
    else
      render :new
    end
  end

  def update
    if @faq.update_attributes(faq_params)
      redirect_to admin_faqs_path, notice: 'Faq updated'
    else
      render :edit
    end
  end

  def destroy
    @faq.destroy
    redirect_to admin_faqs_path, notice: 'Faq removed'
  end

  protected

    def faq_params
      params.require(:faq).permit(:title, :content, :member_only)
    end

    def set_faq
      @faq = Faq.find(params[:id])
    end


end
