class UsersController < ApplicationController
  def index
    @users = User.ranked
    respond_with(@users)
  end

  def show
    @user = User.find params[:id]
    respond_with @user
  end
end
