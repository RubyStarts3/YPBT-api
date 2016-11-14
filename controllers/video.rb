# frozen_string_literal: true

# GroupAPI web service
class YPBT_API < Sinatra::Base
  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}

  get "/#{API_VER}/video/:video_id/?" do
    video_id = params[:video_id]
    begin
      video = Video.find(video_id: video_id)

      content_type 'application/json'
      { video_id: video_id, title: video.title }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Video (video_id: #{video_id}) not found"
    end
  end

  # Body args (JSON) e.g.: {"url": "https://www.youtube.com/watch?v=video_id"}
  post "/#{API_VER}/video/?" do
    begin
      body_params = JSON.parse request.body.read
      yt_video_url = body_params['url']
      video_id = yt_video_url.match(YT_URL_REGEX)[1]

      if Video.find(video_id: video_id)
        halt 422, "Video (video_id: #{video_id})already exists"
      end

      video = YoutubeVideo::Video.find(video_id: video_id)
    rescue
      content_type 'text/plain'
      halt 400, "Video (video_id: #{video_id}) could not be found"
    end

    begin
      yt_video = Video.create(video_id: video_id, title: video.title)

      video.commentthreads.each do |comment|
        Comment.create(
          video_id:           yt_video.id,
          comment_id:         comment.comment_id,
          updated_at:         comment.updated_at,
          published_at:       comment.published_at,
          text_display:       comment.text_display,
          author_name:        comment.author&.author_name,
          author_image_url:   comment.author&.author_image_url,
          author_channel_url: comment.author&.author_channel_url,
          like_count:         comment.author&.like_count
        )
      end

      content_type 'application/json'
      { video_id: yt_video.id, title: yt_video.title }.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create video (video_id: #{video_id})"
    end
  end

  put "/#{API_VER}/video/:video_id/?" do
    video_id = params[:video_id]
    begin
      video = Video.find(video_id: video_id)
      halt 400, "Video (video_id: #{video_id}) is not stored" unless video
      commentthreads = Comment.where(video_id: video.id).all

      updated_video = YoutubeVideo::Video.find(video_id: video_id)
      if updated_video.nil?
        halt 404, "Video (video_id: #{video_id}) not found on Youtube"
      end

      video.update(video_id: video_id, title: video.title)
      commentthreads.map do |comment|
        comment.delete
      end
      updated_video.commentthreads.each do |comment|
        Comment.create(
          video_id:           video.id,
          comment_id:         comment.comment_id,
          updated_at:         comment.updated_at,
          published_at:       comment.published_at,
          text_display:       comment.text_display,
          author_name:        comment.author&.author_name,
          author_image_url:   comment.author&.author_image_url,
          author_channel_url: comment.author&.author_channel_url,
          like_count:         comment.author&.like_count
        )
      end

      content_type 'text/plain'
      body 'Update to lastest'
    rescue
      content_type 'text/plain'
      halt 500, "Cannot update posting (id: #{posting_id})"
    end
  end
end
