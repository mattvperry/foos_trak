class RankingsController < ApplicationController
  def index
    @users = User.all.sort_by(&:rank).reverse
    respond_with(@users)
  end
end
