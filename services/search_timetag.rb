# frozen_string_literal: true

# Search timetag info from database
class SearchTimetag
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :get_timetag_info, lambda { |params|
    timetag_id = params[:timetag_id]
    timetag_info  = TimetagInfo.new(id: timetag_id)
    timetag_found = TimetagRecord.find(timetag_info)

    if timetag_found
      Right(timetag_info: timetag_found)
    else
      Left(Error.new(:not_found,
                     "Timetag (timetag_id: #{timetag_id}) not found"))
    end
  }

  register :get_timetag_comment_info, lambda { |input|
    timetag_id = input[:timetag_info].id
    comment_found = GetTimetagCommentInfoQuery.call(timetag_id)
    if comment_found
      Right(timetag_info: input[:timetag_info],
            comment_info: comment_found)
    else
      Left(Error.new(:internal_error,
        "Fail to get comment info (timetag_id: #{timetag_id})"))
    end
  }

  register :get_timetag_author_info, lambda { |input|
    timetag_id = input[:timetag_info].id
    author_found = GetTimetagAuthorInfoQuery.call(timetag_id)
    if author_found
      Right(timetag_info: input[:timetag_info],
            comment_info: input[:comment_info],
            author_info:  author_found)
    else
      Left(Error.new(:internal_error,
        "Fail to get author info (timetag_id: #{timetag_id})"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :get_timetag_info
      step :get_timetag_comment_info
      step :get_timetag_author_info
    end.call(params)
  end
end
