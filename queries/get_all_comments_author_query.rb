# frozen_string_literal: true

# Get all comments' info of one assigned video from database
class GetAllCommentsAuthorQuery
  def self.call(comments_info)
    authors_found = comments_info.map do |comment_info|
      author_info  = AuthorInfo.new(comment_id: comment_info.id)
      author_found = AuthorRecord.find(author_info)
    end
  end
end
