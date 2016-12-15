# frozen_string_literal: true

# Search comment info from database
class SearchComment
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :get_comment_info, lambda { |params|
    comment_id    = params[:comment_id]
    comment_info  = CommentInfo.new(comment_id: comment_id)
    comment_found = CommentRecord.find(comment_info)

    if comment_found
      Right(comment_info: comment_found)
    else
      Left(Error.new(:not_found,
                     "Comment (comment_id: #{comment_id}) not found"))
    end
  }

  register :get_comment_video_info, lambda { |input|
    comment_id = input[:comment_info].comment_id
    video_found = GetCommentVideoInfoQuery.call(comment_id)
    if video_found
      Right(comment_info: input[:comment_info],
            video_info:   video_found)
    else
      Left(Error.new(:internal_error,
        "Fail to get video info (comment_id: #{comment_id})"))
    end
  }

  register :get_comment_author_info, lambda { |input|
    comment_id = input[:comment_info].comment_id
    author_found = GetCommentAuthorInfoQuery.call(comment_id)
    if author_found
      Right(comment_info: input[:comment_info],
            video_info:   input[:video_info],
            author_info:  author_found)
    else
      Left(Error.new(:internal_error,
        "Fail to get author info (comment_id: #{comment_id})"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :get_comment_info
      step :get_comment_video_info
      step :get_comment_author_info
    end.call(params)
  end
end
