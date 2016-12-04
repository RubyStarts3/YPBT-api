# frozen_string_literal: true

# Represents overall timetag information for JSON API output
class TimetagInfoRepresenterA
  attr_reader :timetag_info, :time_tag_id, :start_time, :end_time, :like_count,
              :unlike_count, :tag_type, :comment_text_display,
              :comment_author_name, :comment_author_image_url,
              :comment_author_channel_url

  def initialize(timetag_info)
    @timetag_info               = timetag_info
    @time_tag_id                = set_time_tag_id(@timetag_info)
    @start_time                 = set_start_time(@timetag_info)
    @end_time                   = set_end_time(@timetag_info)
    @like_count                 = set_like_count(@timetag_info)
    @unlike_count               = set_unlike_count(@timetag_info)
    @tag_type                   = set_tag_type(@timetag_info)
    @comment_text_display       = set_comment_text_display(@timetag_info)
    @comment_author_name        = set_comment_author_name(@timetag_info)
    @comment_author_image_url   = set_comment_author_image_url(@timetag_info)
    @comment_author_channel_url = set_comment_author_channel_url(@timetag_info)
  end

  def to_json
    { time_tag_id:                @time_tag_id,
      start_time:                 @start_time,
      end_time:                   @end_time,
      like_count:                 @like_count,
      unlike_count:               @unlike_count,
      tag_type:                   @tag_type,
      comment_text_display:       @comment_text_display,
      comment_author_name:        @comment_author_name,
      comment_author_image_url:   @comment_author_image_url,
      comment_author_channel_url: @comment_author_channel_url
    }.to_json
  end

  def set_time_tag_id(timetag_info)
    timetag_info.id
  end

  def set_start_time(timetag_info)
    duration_in_second = timetag_info.start_time
    unless duration_in_second.nil?
      Duration.new(duration_in_second).iso8601
    else
      nil
    end
  end

  def set_end_time(timetag_info)
    duration_in_second = timetag_info.end_time
    unless duration_in_second.nil?
      Duration.new(duration_in_second).iso8601
    else
      nil
    end
  end

  def set_like_count(timetag_info)
    timetag_info.yt_like_count + timetag_info.our_like_count
  end

  def set_unlike_count(timetag_info)
    timetag_info.our_unlike_count
  end

  def set_tag_type(timetag_info)
    timetag_info.tag_type
  end

  def set_comment_text_display(timetag_info)
    timetag_info.text_display
  end

  def set_comment_author_name(timetag_info)
    timetag_info.author_name
  end

  def set_comment_author_image_url(timetag_info)
    timetag_info.author_image_url
  end

  def set_comment_author_channel_url(timetag_info)
    timetag_info.author_channel_url
  end
end