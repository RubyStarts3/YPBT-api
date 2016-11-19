# frozen_string_literal: true

# Represents overall video information for JSON API output
class CommentRepresenter < Roar::Decorator
  include Roar::JSON

  property :comment_id
  property :author_name
  property :author_image_url
  property :author_channel_url
  property :like_count
end
