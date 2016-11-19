# frozen_string_literal: true

# Create a new video and its downstream data in the database
class LoadVideoFromYT
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}

  register :check_video, lambda { |request|
    body_params = JSON.parse request.body.read
    video_url = body_params['url']
    video_id = video_url.match(YT_URL_REGEX)[1]

    if Video.find(video_id: video_id).nil?
      Right(video_id: video_id)
    else
      Left(Error.new(:cannot_process, 
        "Video (video_id: #{video_id})already exists"))
    end
  }

  register :fetch_video_data, lambda { |input|
    begin
      video = YoutubeVideo::Video.find(video_id: input[:video_id])
      find = true
    rescue
      find = false
    end
    # need revise

    if find
      Right(video: video, video_id: input[:video_id]) # need revise
    else
      Left(Error.new(:bad_request,
        "Video (video_id: #{input[:video_id]}) could not be found"))
    end
  }

  register :create_new_video_record, lambda { |input|
    success = CreateVideoFromYT.call(input[:video], input[:video_id])
                                                      # need revise

    if success
      Right(video: input[:video], video_id: input[:video_id]) # need revise
    else
      Left(Error.new(:internal_error,
        "Cannot create video (video_id: #{input[:video_id]})"))
    end
  }

  register :render_video_info, lambda { |input|
    results = VideoInfo.new(
      input[:video_id], input[:video].title, input[:video].description,
       # need revise
      input[:video].view_count , input[:video].like_count,
      input[:video].dislike_count, "" # input[:video].duration need revise
    )
    Right(results)
  }


  def self.call(params)
    Dry.Transaction(container: self) do
      step :check_video # is not existed in database
      step :fetch_video_data
      step :create_new_video_record # and its downstream data
      step :render_video_info
    end.call(params)
  end
end
