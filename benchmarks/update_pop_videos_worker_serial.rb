require 'benchmark'

videos_pop = YoutubeVideo::Video.find_popular(max_results: 20)
videos_pop_info = FillPopVideosInfoQuery.call(videos_pop)

time = Benchmark.measure do
  videos_pop_info.each do |video_pop|
    video_id = video_pop.video_id
    UpdatePopVideosWorker.perform_async(video_id)
  end
end.real

puts time

# LOCAL  => 7.506250070407987
# HEROKU => 4.660539041040465
