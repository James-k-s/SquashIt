class InviteMailer < ApplicationMailer
  default from: "no-reply@squashit.com"

  def invite_email
    @invite = params[:invite]
    @tournament = @invite.tournament
    mail to: @invite.email, subject: "You're invited to #{@tournament.name}"
  end
end
