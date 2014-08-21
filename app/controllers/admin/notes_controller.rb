class Admin::NotesController < ApplicationController
  layout 'admin_application'

  def index
    @notes = Note.includes(:user, :specialty, :noteable).order(id: :desc).paginate(page: params[:page])
  end

  def show
    @note = Note.find(params[:id])
  end

end
