# frozen_string_literal: true

# Represent mingle comment information for JSON API output
class TimetagGeneralRepresenter
  attr_accessor :timetag_info

  def initialize(timetag_info)
    @timetag_info = timetag_info
  end

  def to_json
    { time_tag_id:                @timetag_info.id,
      start_time:                 @timetag_info.start_time,
      end_time:                   @timetag_info.end_time,
      tag_type:                   @timetag_info.tag_type,
      start_time_percentage:      @timetag_info.start_time_percentage,
      end_time_percentage:        @timetag_info.end_time_percentage,
      click_count:                @timetag_info.click_count,
      like_count:                 set_like_count(@timetag_info)
    }.to_json
  end

  def set_like_count(timetag_info)
    timetag_info.yt_like_count + timetag_info.our_like_count
  end
end
