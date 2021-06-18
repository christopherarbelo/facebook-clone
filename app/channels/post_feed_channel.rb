class PostFeedChannel < ApplicationCable::Channel
  def subscribed
    stream_from "post_feed_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
