class CatRentalRequestsController < ApplicationController
  before_action :require_logged_in
  before_action :require_cat_owner, only: %i[approve deny]

  def require_cat_owner
    @cat = current_user.cats.find_by(id: params[:id])
    redirect_to cats_url if @cat.nil?
  end

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
    # Grab the cat_id from params if it exists.
    # If it doesn't exist, :cat_id will still be nil.
    @rental_request.cat_id = params[:cat_id]
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
