class CatsController < ApplicationController
  before_action :require_logged_in, only: %i[new create edit update]
  before_action :require_cat_owner, only: %i[edit update]

  def require_cat_owner
    @cat = current_user.cats.find_by(id: params[:id])
    redirect_to cats_url if @cat.nil?
  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    # debugger
    params[:cat][:owner_id] = current_user.id
    debugger
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      # debugger
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find_by(id: params[:id])

    render :edit
  end

  def update
    @cat = current_user.cats.find_by(id: params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:birth_date, :color, :description, :name, :sex, :owner_id)
  end
end
