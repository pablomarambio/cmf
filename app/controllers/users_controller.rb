class UsersController < ApplicationController
  #before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to sign_up_steps_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
    else
      flash[:alert] = "Unable to update profile"
    end
    if @user.has_role? :admin
      redirect_to users_path
    else
      redirect_to profile_path
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end
