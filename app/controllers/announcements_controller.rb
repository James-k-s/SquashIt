class AnnouncementsController < ApplicationController

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @announcement = @tournament.announcements.new(announcement_params)
    @announcement.user_id = current_user.id
    if @announcement.save
      redirect_to @tournament, notice: 'Announcement was successfully posted.'
    else
      redirect_to @tournament, alert: 'Error posting announcement.'
    end

  end

  private

  def announcement_params
    params.require(:announcement).permit(:body)
  end
end
