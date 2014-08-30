class RankingsController < ApplicationController
  def index
    @users = User.all
    respond_with(@users)
  end
end
