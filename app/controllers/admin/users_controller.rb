module Admin
  class UsersController < Admin::ApplicationController
    before_action :authorised?
    before_action :find_user, except: :index
    respond_to :html, :json

    def index
      @users = User.all
      respond_with @users
    end

    def show
      respond_with @user
    end

    def edit
      @user
    end

    def update
      respond_to do |format|
        remove_password if params[:user][:password].blank?

        if @user.update_attributes(params[:user])
          message = 'user was successfully updated.'
          format.html { redirect_to admin_user_path(@user), notice: message }
        else
          format.html { render action: "edit" }
        end
      end
    end

    def destroy
      if @user.destroy
        flash[:notice] = 'User successfully destroyed'
      else
        flash[:error] = 'Could not destroy the user'
      end

      respond_to do |format|
        format.html { redirect_to admin_users_url }
      end
    end

    private

    def remove_password
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    def find_user
      @user ||= User.find(params[:id])
    end
  end
end
