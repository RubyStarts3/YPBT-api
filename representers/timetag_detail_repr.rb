# frozen_string_literal: true

# Represent mingle comment information for JSON API output
class TimetagDetailRepresenter
  attr_accessor :comment_info, :timetag_info, :author_info

  def initialize(comment_info, timetag_info, author_info)
    @comment_info = comment_info
    @timetag_info = timetag_info
    @author_info  = author_info
  end

  def to_json
    { time_tag_id:                @timetag_info.id,
      start_time:                 @timetag_info.start_time,
      end_time:                   @timetag_info.end_time,
      click_count:                @timetag_info.click_count,
      like_count:                 set_like_count(@timetag_info),
      dislike_count:              @timetag_info.our_dislike_count,
      tag_type:                   @timetag_info.tag_type,
      comment_text_display:       @comment_info.text_display,
      comment_author_name:        @author_info.author_name,
      comment_author_image_url:   @author_info.author_image_url,
      comment_author_channel_url: @author_info.author_channel_url

    }.to_json
  end

  def set_like_count(timetag_info)
    timetag_info.yt_like_count + timetag_info.our_like_count
  end
end
