require 'benchmark'

videos_pop = YoutubeVideo::Video.find_popular(max_results: 20)
videos_pop_info = FillPopVideosInfoQuery.call(videos_pop)

time = Benchmark.measure do
  promised_updates = videos_pop_info.map do |video_pop|
    video_id = video_pop.video_id
    Concurrent::Promise.execute do
      UpdatePopVideosWorker.perform_async(video_id)
    end
  end
  promised_updates.map(&:value)
end.real

puts time

# LOCAL  => 1.0882823877036572
# HEROKU => 0.7573032309301198
