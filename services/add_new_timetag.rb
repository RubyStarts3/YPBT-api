# frozen_string_literal: true

# Add new timetag
class AddNewTimetag
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :api_key_authenticate, lambda { |request|
    body_params = JSON.parse request.body.read
    api_key = body_params['api_key']

    if api_key == ENV['YOUTUBE_API_KEY']
      params = body_params
      Right(params)
    else
      Left(Error.new(:forbidden, "Authentication fail"))
    end
  }

  register :check_video, lambda { |params|
    video_id = params['video_id']
    video_info = VideoInfo.new(video_id: video_id)
    video_found = VideoRecord.find(video_info)

    if video_found.nil?
      video_found = try_find_from_YPBTgem(video_id)
    end

    unless video_found.nil?
      Right(video_info: video_found, params: params)
    else
      Left(Error.new(:bad_request, 
        "Video (video_id: #{video_id}) is not available"))
    end
  }

  register :add_new_timetag, lambda { |input|
    timetag_id = AddNewTimetagQuery.call(input[:video_info], input[:params])

    unless timetag_id.nil?
      Right(timetag_id)
    else
      Left(Error.new(:internal_error,
        "Cannot add new time_tag in choosed video " +
        "(video_id: #{input['video_id']})"))
    end
  }

  register :render_timetag_info, lambda { |timetag_id|
    timetag = Timetag.find(id: timetag_id)
    results = TimetagInfo.new(
      id:                    timetag.id,
      start_time:            timetag.start_time,
      end_time:              timetag.end_time,
      click_count:           timetag.click_count,
      yt_like_count:         timetag.yt_like_count,
      our_like_count:        timetag.our_like_count,
      tag_type:              timetag.tag_type,
      start_time_percentage: timetag.start_time_percentage,
      end_time_percentage:   timetag.end_time_percentage
    )
    Right(results)
  }

  register :render_api_info, lambda { |params|
    results = ApiInfo.new("Add new time_tag in choosed video " +
                          "(video_id: #{params['video_id']})")
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :api_key_authenticate
      step :check_video # is already stored in database
      step :add_new_timetag
      step :render_timetag_info
      #step :render_api_info
    end.call(params)
  end

  def self.try_find_from_YPBTgem(video_id)
    video_raw = YoutubeVideo::Video.find(video_id: video_id)
    unless video_raw.nil?
      video_record = YPBTParserVideoOnly.call(video_raw).first
      video_found = video_record.video_info
    else
      nil
    end
  end
end
