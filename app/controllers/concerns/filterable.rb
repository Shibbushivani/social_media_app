module Filterable
  extend ActiveSupport::Concern
  
  included do
    before_action :authenticate_user!
    before_action :set_user
    before_action :set_post, only: [:like, :unlike]
    before_action :set_user_post, only: [:edit, :update, :destroy, :show]
  end   
  
  def like
    like = @post.like
    @post.update_attribute(:like, like.push(current_user.id))
    create_notification_for_like(@post)
    message = "liked your post"
    update_show(@user)
  end

  def unlike
    like = @post.like - [current_user.id]
    @post.update_attribute(:like, like)
    update_show(@user)
  end 
  
  def create_notification_for_like(post)
    Notification.create do |notification|
      notification.notify_type = 'post'
      notification.actor = post.user
      notification.user = post.user
      notification.target = post
      notification.target_type = 'Like'
      notification.second_target = post
    end
  end

  def update_show(user)
    @posts = params[:user_id] ? @user.posts.order('created_at ASC') : Post.all.order('created_at ASC')
    respond_to do |format|
      if params[:user_id].present?
        format.html { redirect_to user_path(@user) }
      else
        format.html { redirect_to users_path }
      end
      format.js {}
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_post
    @post = @user.posts.find(params[:id])
  end
  
  def set_post
    @post = Post.find(params[:id])
  end 

  def post_params
    params.require(:post).permit(:user_id, :description, :avatar, :avatar_cache)
  end
end