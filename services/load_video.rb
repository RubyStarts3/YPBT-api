# frozen_string_literal: true

# Loads data from Facebook group to database
class LoadVideoFromYT
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}

  register :validate_request_json, lambda { |request_body|
    begin
      url_representation = UrlRequestRepresenter.new(UrlRequest.new)
      Right(url_representation.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :validate_request_url, lambda { |body_params|
    if (video_url = body_params['url']).nil?
      Left(:cannot_process, 'URL not supplied'
    else
      Right(video_url)
    end
  }

  register :parse_video_id, lambda { |video_url|
    if (video_id = video_url.match(YT_URL_REGEX)[1]).nil?
      Left(Error.new(:cannot_process, 'URL not recognized as Video id'))
    else
      Right(video_id)
    end
  }

  # need revised
  register :retrieve_video_and_others_data, lambda { |video_id|
    if Video.find(video_id: video_id)
      Left(Error.new(:cannot_process, 'Video already exists'))
    else
      Right(YoutubeVideo::Video.find(video_id: video_id))
    end
  }

  # need to be seperated
  register :create_video_and_comments_and_more, lambda { |video_id|
    new_video_record = write_video(video)

    video.comments.each do |comment|
      new_comment_record = write_video_comment(new_video_record, comment)
    end

    time_tags = comment.time_tags
    time_tags.each do |time_tag|
    existed_time_tag = Timetag.find(comment_id: comment.comment_id,
                                    start_time: time_tag.start_time)
        if existed_time_tag.nil?
          write_timetag(new_comment_record, comment, time_tag)
        end
    end

    author = comment.author
    write_author(new_comment_record, author)
    end
    # { state: "success!"}.to_json
    Right(video)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :validate_request_url
      step :parse_video_id
      step :retrieve_video_and_others_data
      step :create_video_and_comments_and_more
    end.call(params)
  end

  private_class_method
 # have not tested
  def self.write_video_comment(new_video_record, comment)
    Comment.create(
      video_id:      new_video_record.id,
      comment_id:    comment.comment_id,
      published_at:  comment.published_at,
      updated_at:    comment.updated_at ? comment.updated_at : "",
      text_display:  comment.text_display,
      like_count:    comment.like_count
    )
  end

  def self.write_video(video)
    Video.create(
      video_id: video_id,# Need Revise
      title: video.title,
      description: video.description,
      view_count: video.view_count,
      like_count: video.like_count,
      dislike_count: video.dislike_count,
      #duration: video.duration, # Need Revise
      last_update_time: Time.now
    )
  end

  def self.write_timetag(new_comment_record, comment, time_tag)
    Timetag.create(
      comment_id:    new_comment_record.id,
      yt_like_count: comment.like_count,
      our_like_count: 0,
      start_time:    time_tag.start_time,
        )
  end

  def self.write_author(new_comment_record, author)
    Author.create(
      comment_id:         new_comment_record.id,
      author_name:        author.author_name,
      author_image_url:   author.author_image_url,
      author_channel_url: author.author_channel_url,
      like_count:         author.like_count
    )
  end
end
