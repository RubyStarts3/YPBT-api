# frozen_string_literal: true

# Search popular videos info from YPBT gem
class SearchPopVideo
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_invalid_query_number, lambda { |params|
    max_results = params[:number].to_i

    if max_results == 0 || max_results > 50
      Left(Error.new(:not_found, "No information available now"))
    else
      Right(params)
    end
  }

  register :get_pop_videos_info, lambda { |params|
    max_results = params[:number]
    videos_pop = YoutubeVideo::Video.find_popular(max_results: max_results)
    videos_pop_info = FillPopVideosInfoQuery.call(videos_pop)

    unless videos_pop_info.nil?
      Right(videos_pop_info: videos_pop_info)
    else
      Left(Error.new(:not_found, "No information available now"))
    end
  }

  register :update_pop_videos_worker, lambda { |params|
    videos_pop_info = params[:videos_pop_info]

    promised_updates = videos_pop_info.map do |video_pop|
      video_id = video_pop.video_id
      Concurrent::Promise.execute do
        UpdatePopVideosWorker.perform_async(video_id)
      end
    end
    promised_updates.map(&:value)

    Right(videos_pop_info: videos_pop_info)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :check_invalid_query_number
      step :get_pop_videos_info
      step :update_pop_videos_worker
    end.call(params)
  end
end
