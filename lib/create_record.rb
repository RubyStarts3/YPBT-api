# frozen_string_literal: true

# Create new record
class CreateRecord
  # Create new video record
  def self.new_video(video_info)
    created_video = Video.create(
      video_id:         video_info.video_id,
      title:            video_info.title,
      description:      video_info.description,
      view_count:       video_info.view_count,
      like_count:       video_info.like_count,
      dislike_count:    video_info.dislike_count,
      duration:         video_info.duration,
      last_update_time: Time.now
    )
  end

  # Create new comment record
  def self.new_comment(comment_info)
    created_comment = Comment.create(
      video_id:      comment_info.video_id,
      comment_id:    comment_info.comment_id,
      published_at:  comment_info.published_at,
      updated_at:    comment_info.updated_at,
      text_display:  comment_info.text_display,
      like_count:    comment_info.like_count
    )
  end

  # Create new timetag record
  def self.new_timetag(timetag_info)
    existed_timetag = Timetag.find(comment_id: timetag_info.comment_id,
                                   start_time: timetag_info.start_time)
    return existed_timetag unless existed_timetag.nil?

    Timetag.create(
      comment_id:     timetag_info.comment_id,
      yt_like_count:  timetag_info.yt_like_count,
      our_like_count: timetag_info.our_like_count,
      start_time:     timetag_info.start_time,
    )
  end

  # Create new author record
  def self.new_author(author_info)
    Author.create(
      comment_id:         author_info.comment_id,
      author_name:        author_info.author_name,
      author_image_url:   author_info.author_image_url,
      author_channel_url: author_info.author_channel_url,
      like_count:         author_info.like_count
    )
  end
end
