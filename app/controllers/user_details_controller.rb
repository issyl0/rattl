class UserDetailsController < ApplicationController
  before_action :set_user_detail, only: [:show, :edit, :update, :destroy]

  def index
    @user_details = UserDetail.all
  end

  def show
  end

  def new
    @user_detail = UserDetail.new
  end

  def edit
  end

  def create
    @user_detail = UserDetail.new(user_detail_params)
    @user_detail.user_id = current_user.id

    respond_to do |format|
      if @user_detail.save
        # IL TODO: change redirect to go to skills page.
        format.html { redirect_to root_path, notice: 'Details successfully saved.' }
        format.json { render action: 'show', status: :created, location: @user_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_detail.update(user_detail_params)
        format.html { redirect_to @user_detail, notice: 'User detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_detail.destroy
    respond_to do |format|
      format.html { redirect_to user_details_url }
      format.json { head :no_content }
    end
  end

  private
    def set_user_detail
      @user_detail = UserDetail.find(params[:id])
    end

    def user_detail_params
      params.require(:user_detail).permit(:forename, :surname, :gender, :postcode, :dob)
    end
end
