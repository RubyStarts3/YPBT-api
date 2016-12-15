# frozen_string_literal: true

# YPBT-API web service
class YPBT_API < Sinatra::Base
  #YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}

  # Get comment info from database
  # tux: get 'api/v0.1/comment/:comment_id'
  get "/#{API_VER}/Comment/:comment_id/?" do
    results = SearchComment.call(params)

    if results.success?
      CommentMingleRepresenter.new(
        results.value[:video_info],
        results.value[:comment_info],
        results.value[:author_info]
      ).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Get all comments' info of one assigned video from database
  # tux: get 'api/v0.1/Comments/:video_id'
  get "/#{API_VER}/Comments/:video_id" do
    results = SearchVideoAllComments.call(params)

    if results.success?
      CommentMingleThreadRepresenter.new(
        results.value[:video_id],
        results.value[:comments_info],
        results.value[:authors_info]
      ).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
