class Admin::AuthorsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html

  def index
    @authors = Author.all
  end

  def new
    @author = Author.new
  end

  def show
    @author = Author.find(params[:id])
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to admin_authors_path, notice: 'Author created'
    else
      render :new
    end
  end

  def update
    @author = Author.find(params[:id])
    if @author.update_attributes(author_params)
      redirect_to admin_author_path(@author), notice: 'Author updated'
    else
      render :edit
    end
  end

  def destroy
  end

  private

    def author_params
      params.require(:author).permit(:name, :tagline, :twitter, :facebook, :avatar)
    end

end
