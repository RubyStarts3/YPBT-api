# frozen_string_literal: true

class TimetagInfo
  attr_accessor :id, :comment_id, :click_count, :yt_like_count, :our_like_count,
                :our_dislike_count, :start_time, :end_time, :tag_type,
                :start_time_percentage, :end_time_percentage

  def initialize(id: nil, comment_id: nil, click_count: nil, yt_like_count: nil,
                 our_like_count: nil, our_dislike_count: nil, start_time: nil,
                 end_time: nil, tag_type: nil, start_time_percentage: nil,
                 end_time_percentage: nil)
    @id = id
    @comment_id = comment_id
    @click_count = click_count
    @yt_like_count = yt_like_count
    @our_like_count = our_like_count
    @our_dislike_count = our_dislike_count
    @start_time = start_time
    @end_time = end_time
    @tag_type = tag_type
    @start_time_percentage = start_time_percentage
    @end_time_percentage = end_time_percentage
  end
end
