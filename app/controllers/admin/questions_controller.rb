class Admin::QuestionsController < ApplicationController
  layout 'admin_application'
  before_action :set_video, only: [:new, :edit, :update, :create, :destroy, :mark_proofread]
  before_action :set_question, only: [:edit, :update, :destroy, :mark_proofread]

  def index
    @q = Question.search(params[:q])
    @questions = apply_scopes(@q.result.includes(:video).order(id: :desc).paginate(page: params[:page]))
  end

  def new
    @question = @video.questions.new
  end

  def create
    @question = @video.questions.create(permitted_params)
    if @question.save
      redirect_to admin_video_path(@video), notice: 'Question added'
    else
      flash.now.alert = 'Please review the form'
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(permitted_params)
      redirect_to admin_video_path(@video)
    else
      flash.now.alert = 'Please review the form'
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_video_path(@video), notice: 'Question removed'
  end

  def mark_proofread
    @question.update_attributes(proofread: true)
    redirect_to admin_video_path(@video), notice: 'Question marked as proofread'
  end

  protected

    def set_video
      @video = Video.friendly.find(params[:video_id])
    end

    def set_question
      @question = Question.find(params[:id])
    end

    def permitted_params
      params.require(:question).permit(:stem, :answer_1, :answer_2, :answer_3, :answer_4, :answer_5,
                                      :correct_answer, :explanation, :proofread)
    end

end
