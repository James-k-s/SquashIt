class TournamentsController < ApplicationController

  def show
    @tournament = Tournament.find(params[:id])
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.created_by_user_id = current_user.id
    if @tournament.save!
      redirect_to @tournament, notice: 'Tournament was successfully created.'
    else
      flash.now[:alert] = 'There was an error creating the tournament.'
      render :new
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start_date, :end_date, :location, :description, :bracket_type, :max_players, :min_players)
  end
end
