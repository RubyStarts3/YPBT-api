# frozen_string_literal: true

# Commentthreads routes
class YPBT_API < Sinatra::Base
  #include WordMagic

  # TODO: allow search for the first three comments in a video
  get "/#{API_VER}/video/:video_id/commentthreads/?" do
    video_id = params[:video_id]
    begin
      video = Video.find(video_id: video_id)
      halt 400, "Video (video_id: #{video_id}) not found" unless video
      commentthreads = Comment.where(video_id: video.id).all

      content_type 'application/json'
      commentthreads.first(3).map do |comment|
        content = { author_name: comment.author_name }
        content[:comment_text] = comment.text_display
        content[:like_count] = comment.like_count
        content[:author_channel_url] = comment.author_channel_url
        content
      end.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Video (video_id: #{video_id}) could not be processed"
    end
  end
end
