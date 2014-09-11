class GamesController < ApplicationController
  include GamesHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :check_players, only: [:update, :destroy]

  respond_to :html, except: :match_quality

  def index
    @games = Game.includes(teams: :users)
      .order(created_at: :desc)
      .page params[:page]
    respond_with(@games)
  end

  def match_quality
    required_params = [:team1ids, :team2ids]

    if required_params.map { |sym| params[sym].present? }.all?
      teams = required_params.map do |team|
        params[team].map { |id| User.find id }
      end

      @quality = TrueskillHelper.match_quality *teams
    end

    respond_with @quality
  end

  def show
    respond_with(@game)
  end

  def new
    @game = Game.new
    @game.build_doubles
    respond_with(@game)
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    @game.save
    respond_with(@game)
  end

  def update
    @game.update(game_params)
    respond_with(@game)
  end

  def destroy
    @game.destroy
    respond_with(@game)
  end

  private
  def check_players
    unless can_modify_game(@game)
      flash[:error] = 'You must have participated in this game make modifications.'
      redirect_to :back
    end
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit([
      :creator_id,
      teams_attributes: [
        :id, :goals,
        { players_attributes: [:id, :user_id, :position] }
      ]
    ])
  end
end
