# frozen_string_literal: true

# YPBT-API web service
class YPBT_API < Sinatra::Base
  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}
  COOLDOWN_TIME = 10 # second

  # Get all videos info in database
  # tux: get 'api/v0.1/Videos'
  get "/#{API_VER}/Videos/?" do
    results = SearchVideos.call

    if results.success?
      VideoInfoThreadRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Get video info from YPBT gem
  # tux: get 'api/v0.1/Video/:video_id'
  get "/#{API_VER}/Video/:video_id/?" do
    results = SearchVideo.call(params)

    if results.success?
      VideoInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # get popular videos from YPBT-gem
  get "/#{API_VER}/PopVideos/:number" do
    results = SearchPopVideo.call(params)
=begin
    videos_pop_info = results.value[:videos_pop_info]
    videos_pop_info.each do |video_pop|
      video_id = video_pop.video_id
      UpdatePopVideosWorker.perform_async(video_id)
    end
=end

    if results.success?
      VideoPopThreadRepresenter.new(results.value[:videos_pop_info]).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
