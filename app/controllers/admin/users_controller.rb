class Admin::UsersController < Admin::ApplicationController
  before_filter :authorised?

  respond_to :html, :json

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user
  end



  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to admin_user_path(@user), notice: 'user was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = 'User successfully destroyed'
    else
      flash[:error] = 'Could not destroy the user'
    end 

    respond_to do |format|
      format.html { redirect_to admin_users_url }
    end
  end
end
