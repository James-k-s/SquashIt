class InvitesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :share]
  before_action :set_tournament, only: [:create, :share]

  # POST /tournaments/:tournament_id/invites
  def create
    return redirect_to root_path, alert: "Tournament not found." unless @tournament
    return redirect_to @tournament, alert: "Only the organizer can invite players." unless organizer?

    email = invite_params[:email].to_s.strip.downcase
    expires_at = 14.days.from_now

    invite = @tournament.invites.find_or_initialize_by(email: email.presence)
    invite.token      ||= SecureRandom.urlsafe_base64(24)
    invite.status     ||= "pending"
    invite.expires_at ||= expires_at

    if invite.save
      InviteMailer.with(invite: invite).invite_email.deliver_later if email.present?
      redirect_to @tournament, notice: (email.present? ? "Invitation sent to #{email}." : "Shareable invite ready.")
    else
      redirect_to @tournament, alert: invite.errors.full_messages.to_sentence
    end
  end

  # POST /tournaments/:tournament_id/invites/share(.json)
  def share
    return redirect_to root_path, alert: "Tournament not found." unless @tournament
    unless organizer?
      return respond_to do |f|
        f.html { redirect_to @tournament, alert: "Only the organizer can generate a link." }
        f.json { render json: { error: "Forbidden" }, status: :forbidden }
      end
    end

    invite = @tournament.invites
                        .where(email: nil, status: "pending")
                        .where("expires_at IS NULL OR expires_at > ?", Time.current)
                        .first

    invite ||= @tournament.invites.create!(
      email: nil,
      token: SecureRandom.urlsafe_base64(24),
      status: "pending",
      expires_at: 14.days.from_now
    )

    url = tournament_url(@tournament, invite_token: invite.token)
    respond_to do |f|
      f.html { redirect_to @tournament, notice: "Shareable link: #{url}" }
      f.json { render json: { url: url }, status: :ok }
    end
  end

  # POST /invites/:token/accept
  def accept
    invite = Invite.find_by(token: params[:token], status: "pending")
    return redirect_to root_path, alert: "Invalid invite." unless invite

    if invite.expires_at&.past?
      invite.update(status: "expired")
      return redirect_to root_path, alert: "Invite expired."
    end

    user = resolve_user_for(invite)
    return if performed? # redirected in resolve_user_for

    if capacity_full?(invite.tournament)
      return redirect_to invite.tournament, alert: "Tournament is full."
    end

    Invite.transaction do
      invite.update!(status: "accepted", invited_user: user)
      TournamentPlayer.find_or_create_by!(tournament_id: invite.tournament_id, user_id: user.id) do |tp|
        tp.status = "registered" if tp.respond_to?(:status) && tp.status.blank?
      end
    end

    redirect_to invite.tournament, notice: "You have joined the tournament!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to invite.tournament, alert: e.record.errors.full_messages.to_sentence
  end

  # POST /invites/:token/decline
  def decline
    invite = Invite.find_by(token: params[:token], status: "pending")
    return redirect_to root_path, alert: "Invalid invite." unless invite

    invite.update(status: "declined")
    redirect_to root_path, notice: "Invitation declined."
  end

  # Optional: GET /invites/:token → redirect to tournament with invite_token
  def landing
    invite = Invite.find_by(token: params[:token], status: "pending")
    return redirect_to root_path, alert: "Invalid invite." unless invite
    return redirect_to root_path, alert: "Invite expired." if invite.expires_at&.past?

    redirect_to tournament_url(invite.tournament, invite_token: invite.token)
  end

  private

  def set_tournament
    @tournament = Tournament.find_by(id: params[:tournament_id])
  end

  def organizer?
    current_user && @tournament && current_user.id == @tournament.created_by_user_id
  end

  def invite_params
    params.fetch(:invite, {}).permit(:email)
  end

  # Determines which user can accept this invite, or redirects to login/signup.
  def resolve_user_for(invite)
    if invite.email.present?
      if current_user
        unless current_user.email.casecmp?(invite.email)
          redirect_to root_path, alert: "Logged in as #{current_user.email}. Log out and use #{invite.email}."
          return
        end
        current_user
      else
        user = User.find_by(email: invite.email)
        unless user
          session[:invite_token] = invite.token
          redirect_to new_user_registration_path, alert: "Create an account with #{invite.email} to accept."
          return
        end
        user
      end
    else
      # Share link (no specific email)
      if current_user
        current_user
      else
        session[:invite_token] = invite.token
        redirect_to new_user_session_path, alert: "Log in or sign up to join."
        return
      end
    end
  end

  def capacity_full?(tournament)
    return false unless tournament.respond_to?(:max_players) && tournament.max_players.present?
    count = if tournament.respond_to?(:players)
      tournament.players.count
    else
      TournamentPlayer.where(tournament_id: tournament.id).count
    end
    count >= tournament.max_players
  end
end
