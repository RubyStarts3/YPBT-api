# frozen_string_literal: true

class AuthorInfo
  attr_accessor :id, :comment_id, :author_name, :author_image_url,
                :author_channel_url, :like_count

  def initialize(id: nil, comment_id: nil, author_name: nil, 
                 author_image_url: nil, author_channel_url: nil, 
                 like_count: nil)
    @id = id
    @comment_id = comment_id
    @author_name = author_name
    @author_image_url = author_image_url
    @author_channel_url = author_channel_url
    @like_count = like_count
  end
end
