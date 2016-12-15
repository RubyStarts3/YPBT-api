# frozen_string_literal: true

# Get all timetags' info of one assigned video from database
class SearchVideoAllTimetags
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :update_to_latest, lambda { |params|
    video_id = params[:video_id]
    success = Update2LatestQuery.call(video_id)
    if success
      Right(video_id: video_id)
    else
      Left(Error.new(:bad_request,
           "Video (video_id: #{params[:video_id]}) could not be found"))
    end
  }

  register :get_video_all_timetags, lambda { |input|
    video_id = input[:video_id]
    timetags_found = GetVideoAllTimetagsQuery.call(video_id)

    if timetags_found
      Right(timetags_info: timetags_found)
    else
      Left(Error.new(:not_found, "No record existed (video_id: #{video_id})"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :update_to_latest # update existed record or load new record
      step :get_video_all_timetags
    end.call(params)
  end
end
