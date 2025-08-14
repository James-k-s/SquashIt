class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  def create
    super do |user|
      if session[:invite_token]
        invite = Invite.find_by(token: session[:invite_token], status: "pending")
        if invite
          invite.update(invited_user: user, status: "accepted")
          TournamentPlayer.create(user: user, tournament: invite.tournament)
        end
        session.delete(:invite_token)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
