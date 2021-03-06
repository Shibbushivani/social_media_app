module Notifications
  # NotificationsController
  class NotificationsController < Notifications::ApplicationController
    before_action :authenticate_user!, only: [:clean, :index]

    def index
      @notifications = notifications.includes(:actor, :user, :target, :second_target).order('id desc').page(params[:page])
      unread_ids = @notifications.reject(&:read?).select(&:id)
      Notification.read!(unread_ids)
      @notification_groups = @notifications.group_by { |note| note.created_at.to_date }
    end

    def clean
      notifications.delete_all
      redirect_to notifications_path
    end

    private

    def notifications
      Notification.where(user_id: current_user.id)
    end
  end
end
