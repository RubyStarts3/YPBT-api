# frozen_string_literal: true

# GroupAPI web service
class YPBT_API < Sinatra::Base
  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}
  COOLDOWN_TIME = 10 # second

  get "/#{API_VER}/video/:video_id/?" do
    results = SearchVideo.call(params)

    if results.success?
      VideoInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
=begin
    video_id = params[:video_id]
    begin
      video = Video.find(video_id: video_id)

      content_type 'application/json'
      { video_id: video_id,   # Need Revise
        title: video.title,
        description: video.description,
        view_count: video.view_count,
        like_count: video.like_count,
        dislike_count: video.dislike_count,
        duration: video.duration,
      }.to_json      
    rescue
      content_type 'text/plain'
      halt 404, "Video (video_id: #{video_id}) not found"
    end
=end
  end

  # get all tagid for this video
  get "/#{API_VER}/video/:video_id/get_all_tagid?" do
    content_type 'application/json'
    ["Need Implement"].to_json
  end

  # Body args (JSON) e.g.: {"url": "https://www.youtube.com/watch?v=video_id"}
  post "/#{API_VER}/video/?" do
    begin
      body_params = JSON.parse request.body.read
      video_url = body_params['url']
      video_id = video_url.match(YT_URL_REGEX)[1]

      if Video.find(video_id: video_id)
        halt 422, "Video (video_id: #{video_id})already exists"
      end

      video = YoutubeVideo::Video.find(video_id: video_id)
    rescue
      content_type 'text/plain'
      halt 400, "Video (video_id: #{video_id}) could not be found"
    end

    begin
      new_video_record = Video.create(
        video_id: video_id,                # Need Revise 
        title: video.title,
        description: video.description,
        view_count: video.view_count,
        like_count: video.like_count,
        dislike_count: video.dislike_count,
        #duration: video.duration,    # Need Revise
        last_update_time: Time.now
      )

      video.comments.each do |comment|
        new_comment_record = Comment.create(
          video_id:      new_video_record.id,
          comment_id:    comment.comment_id,
          published_at:  comment.published_at,
          updated_at:    comment.updated_at ? comment.updated_at : "",
          text_display:  comment.text_display,
          like_count:    comment.like_count
        )

        time_tags = comment.time_tags
        time_tags.each do |time_tag|
          Timetag.create(
            comment_id:    new_comment_record.id,
            #yt_like_count: time_tag.like_count, # Need Vevise
            our_like_count: 0,
            start_time:    time_tag.start_time,
          )
        end

        author = comment.author
        Author.create(
          comment_id:         new_comment_record.id,
          author_name:        author.author_name,
          author_image_url:   author.author_image_url,
          author_channel_url: author.author_channel_url,
          like_count:         author.like_count
        )
      end

      content_type 'application/json'
      { video_id: new_video_record.video_id, 
        title: new_video_record.title,
        description: new_video_record.description,
        view_count: new_video_record.view_count,
        like_count: new_video_record.like_count,
        dislike_count: new_video_record.dislike_count,
        duration: new_video_record.duration,
      }.to_json
      #{ state: "success!"}.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create video (video_id: #{video_id})"
    end
  end

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
            Timetag.create(
              comment_id:    new_db_comment.id,
              #yt_like_count: newest_time_tag.like_count, # Need Vevise
              our_like_count: 0,
              start_time:    newest_time_tag.start_time,
            )
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
=begin
          newest_time_tags = newest_comment.time_tags
          newest_time_tags.each do |newest_time_tag|
            db_timetag = Timetag.find(comment_id: db_comment.id,
                                      start_time: newest_time_tag.start_time)
            if db_timetag.nil?
              Timetag.create(
                comment_id:    db_comment.id,
                #yt_like_count: newest_time_tag.like_count, # Need Vevise
                our_like_count: 0,
                start_time:    newest_time_tag.start_time,
              )
            else
              db_timetag.first.update(
                #yt_like_count: newest_time_tag.like_count, # Need Vevise
              )
            end
          end
=end
          # Uncomment this block will break this program, don't know why
          newest_author = newest_comment.author
          db_author = Author.find(comment_id: db_comment.id)
=begin
          db_author.update(
            #author_name:        newest_author.author_name,
            #author_image_url:   newest_author.author_image_url,
            #author_channel_url: newest_author.author_channel_url,
            like_count:         newest_author.like_count
          )           
=end
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
