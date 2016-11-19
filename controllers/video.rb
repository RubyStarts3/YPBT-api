# frozen_string_literal: true

# GroupAPI web service
class YPBT_API < Sinatra::Base
  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}
  COOLDOWN_TIME = 10 # second

  # Get video info from database
  # tux: get 'api/v0.1/video/:video_id'
  get "/#{API_VER}/video/:video_id/?" do
    results = SearchVideo.call(params)

    if results.success?
      VideoInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # get all tagid for this video
  get "/#{API_VER}/video/:video_id/get_all_tagid?" do
    content_type 'application/json'
    ["Need Implement"].to_json
  end

  # Add full record of a new video
  # tux: post 'api/v0.1/video', { url: "youtube_url" }.to_json,
  #                             'CONTENT_TYPE' => 'application/json'
  post "/#{API_VER}/video/?" do

    result = LoadVideoFromYT.call(request.body.read)

    if results.success?
      VideoInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end


  # Update whole record of an existed video in the database
  # tux: put 'api/v0.1/video/:video_id'
  put "/#{API_VER}/video/:video_id/?" do
    video_id = params[:video_id]
    begin
      db_video = Video.find(video_id: video_id)
      halt 400, "Video (video_id: #{video_id}) is not stored" unless db_video

      time_diff = (Time.now - db_video.last_update_time).to_i
      if time_diff < COOLDOWN_TIME
        halt 200, "Already update to lastest"
      end

      newest_video = YoutubeVideo::Video.find(video_id: video_id)
      if newest_video.nil?
        halt 404, "Video (video_id: #{video_id}) not found on Youtube"
      end

      db_video.update(
        title: newest_video.title,
        description: newest_video.description,
        view_count: newest_video.view_count,
        like_count: newest_video.like_count,
        dislike_count: newest_video.dislike_count,
        #duration: newest_video.duration,    # Need Revise
        last_update_time: DateTime.now
      )

      newest_comments = newest_video.comments
      newest_comments.each do |newest_comment|
        db_comment = Comment.find(video_id: db_video.id,
                                  comment_id: newest_comment.comment_id)
        if db_comment.nil?
          new_db_comment = Comment.create(
            video_id:      db_video.id,
            comment_id:    newest_comment.comment_id,
            published_at:  newest_comment.published_at,
            updated_at:    newest_comment.updated_at ? comment.updated_at : "",
            text_display:  newest_comment.text_display,
            like_count:    newest_comment.like_count
          )

          newest_time_tags = newest_comment.time_tags
          newest_time_tags.each do |newest_time_tag|
            existed_time_tag = Timetag.find(comment_id: newest_comment.comment_id,
                                            start_time: newest_comment.start_time)
            if existed_time_tag.nil?
              Timetag.create(
                comment_id:    new_db_comment.id,
                yt_like_count: comment.like_count,
                our_like_count: 0,
                start_time:    newest_time_tag.start_time,
              )
            end
          end

          newest_author = newest_comment.author
          Author.create(
            comment_id:         new_db_comment.id,
            author_name:        newest_author.author_name,
            author_image_url:   newest_author.author_image_url,
            author_channel_url: newest_author.author_channel_url,
            like_count:         newest_author.like_count
          )
        else
          db_comment.update(
            published_at:  newest_comment.published_at,
            updated_at:    newest_comment.updated_at ?
                           newest_comment.updated_at : "",
            text_display:  newest_comment.text_display,
            like_count:    newest_comment.like_count
          )

          newest_time_tags = newest_comment.time_tags
          newest_time_tags.each do |newest_time_tag|
            db_timetag = Timetag.find(comment_id: db_comment.id,
                                      start_time: newest_time_tag.start_time)
            if db_timetag.nil?
              Timetag.create(
                comment_id:    db_comment.id,
                yt_like_count: newest_comment.like_count,
                our_like_count: 0,
                start_time:    newest_time_tag.start_time,
              )
            else
              db_timetag.update(
                yt_like_count: newest_comment.like_count
              )
            end
          end

          newest_author = newest_comment.author
          db_author = Author.find(comment_id: db_comment.id)
          db_author.update(
            author_name:        newest_author.author_name,
            author_image_url:   newest_author.author_image_url,
            author_channel_url: newest_author.author_channel_url,
            like_count:         newest_author.like_count
          )
        end
      end

      content_type 'text/plain'
      body "Update to lastest"
    rescue
      content_type 'text/plain'
      halt 500, "Cannot update posting (id: #{video_id})"
    end
  end
end
