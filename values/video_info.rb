# frozen_string_literal: true

class VideoInfo
  attr_accessor :id, :video_id, :title, :description, :view_count, :like_count,
                :dislike_count, :duration, :channel_id, :channel_title,
                :channel_description, :channel_image_url, :last_update_time

  def initialize(id: nil, video_id: nil, title: nil, description: nil,
                 view_count: nil, like_count:nil, dislike_count: nil,
                 duration: nil, channel_id: nil, channel_title: nil,
                 channel_description: nil, channel_image_url: nil,
                 last_update_time: nil)
    @id = id
    @video_id = video_id
    @title = title
    @description = description
    @view_count = view_count
    @like_count = like_count
    @dislike_count = dislike_count
    @duration = duration
    @channel_id = channel_id
    @channel_title = channel_title
    @channel_description = channel_description
    @channel_image_url = channel_image_url
    @last_update_time = last_update_time
  end
end
