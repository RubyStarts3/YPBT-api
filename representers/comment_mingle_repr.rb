# frozen_string_literal: true

# Represent mingle comment information for JSON API output
class CommentMingleRepresenter
  attr_accessor :video_info, :comment_info, :author_info

  def initialize(video_info, comment_info, author_info)
    @video_info = video_info
    @comment_info = comment_info
    @author_info = author_info
  end

  def to_json
    { video_id:           @video_info.video_id,
      comment_id:         @comment_info.comment_id,
      text_display:       @comment_info.text_display,
      like_count:         @comment_info.like_count,
      author_name:        @author_info.author_name,
      author_image_url:   @author_info.author_image_url,
      author_channel_url: @author_info.author_channel_url
    }.to_json
  end
end
