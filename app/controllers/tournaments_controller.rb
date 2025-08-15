class TournamentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index]

  def index

    if user_signed_in?

      @upcoming_tournaments = Tournament
      .joins(:tournament_players)
      .where(tournament_players: { user_id: current_user.id })
      .where(status: "Scheduled")
      .distinct

      @active_tournaments = Tournament
      .joins(:tournament_players)
      .where(tournament_players: { user_id: current_user.id })
      .where(status: "Active")
      .distinct

      @completed_tournaments = Tournament
      .joins(:tournament_players)
      .where(tournament_players: { user_id: current_user.id })
      .where(status: "Completed")
      .distinct
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
    @announcements = @tournament.announcements if defined?(Announcement)

    @pending_invite =
      if params[:invite_token].present?
        Invite.find_by(token: params[:invite_token], tournament_id: @tournament.id, status: "pending")
      else
        nil
      end

    # Persist token only for logged-out users (so we can finish after signup/login)
    if @pending_invite && !user_signed_in?
      session[:invite_token] = @pending_invite.token
    end
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

    def start
    @tournament = Tournament.find(params[:id])
    if @tournament.status == "Scheduled"
      unless current_user.id == @tournament.created_by_user_id
        return redirect_to @tournament, alert: "Only the organizer can start the tournament."
      end

      if @tournament.update(status: "Active")
        @tournament.announcements.create(body: "🔵 The tournament has started!", user_id: current_user.id)
        redirect_to @tournament, notice: "Tournament started."
      else
        redirect_to @tournament, alert: @tournament.errors.full_messages.to_sentence
      end
    elsif @tournament.status == "Active"
      redirect_to @tournament, alert: "Tournament is already active."
    else
      redirect_to @tournament, alert: "Tournament is already completed."
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start_date, :end_date, :location, :description, :bracket_type, :max_players, :min_players)
  end
end
