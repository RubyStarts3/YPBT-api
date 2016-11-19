# frozen_string_literal: true

# Create a new video and its downstream data in the database using YPBT gem
class CreateVideoFromYT
  def self.call(video)
    # video: Video object from YPBT
    begin
      create_video_record(video)
      success = true
    rescue
      success = false
    end
  end

  def self.create_video_record(video)
    video_info = VideoInfo.new(
      video.id, video.title, video.description, video.view_count,
      video.like_count, video.dislike_count, video.duration
    )
    created_video = CreateRecord.new_video(video_info)
    
    video.comments.each do |comment|
      create_comment_record(created_video.id, comment)
    end
  end

  def self.create_comment_record(video_id, comment)
    comment_info = CommentInfo.new(
      video_id, comment.comment_id, comment.published_at,
      (comment.updated_at ? comment.updated_at : ""),
      comment.text_display, comment.like_count
    )
    created_comment = CreateRecord.new_comment(comment_info)
    
    comment.time_tags.each do |timetag|
      create_timetag_record(created_comment.id, timetag)
    end
    
    create_author_record(created_comment.id, comment.author)
  end

  def self.create_timetag_record(comment_id, timetag)
    timetag_info = TimetagInfo.new(
      comment_id, timetag.like_count, 0, timetag.start_time
    )
    created_timetag = CreateRecord.new_timetag(timetag_info)
  end

  def self.create_author_record(comment_id, author)
    author_info = AuthorInfo.new(
      comment_id, author.author_name, author.author_image_url,
      author.author_channel_url, author.like_count
    )
    created_author = CreateRecord.new_author(author_info)
  end
end
