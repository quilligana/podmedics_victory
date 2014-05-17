class CommentsController < ApplicationController
  before_action :set_comment, only: [:accept, :vote, :destroy]
  respond_to :html, :js

  def create
    @commentable = find_commentable params

    if params[:comment][:commentable_type] == "SpecialtyQuestion"
      @comment = @commentable.answers.new(comment_params)
      current_user.add_points_for_specialty_answer
      question_specialty = SpecialtyQuestion.find_by(id: params[:comment][:commentable_id]).specialty
      UserProgress.new(question_specialty, current_user).award_badge
    else
      @comment = @commentable.comments.new(comment_params)
    end

    @comment.user = current_user

    unless @comment.save
      @comment = nil
    else
      AdminMailer.delay.new_comment(@comment)

      # If the comment is a reply, send an email to the user
      if params[:comment][:commentable_type] == "Comment"
        UserMailer.delay.new_reply(@commentable, @comment)
      end
    end
  end

  def accept
    @comment.root.accept_answer(@comment, current_user)
  end

  def vote
    @comment.vote(current_user)
  end

  def destroy
    if @comment.cached_user == current_user || current_user.admin?
      @comment.destroy
      redirect_to :back, notice: "Successfully destroyed comment."
    else
      render status: :forbidden
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def find_commentable(params)
      if params[:comment][:commentable_type] == "Video"
        params[:comment][:commentable_type].classify.constantize.friendly.find(params[:comment][:commentable_id])
      else
        params[:comment][:commentable_type].classify.constantize.find(params[:comment][:commentable_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type)
    end
end
