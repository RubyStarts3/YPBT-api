# frozen_string_literal: true

# Represents overall video information for JSON API output
class CommentRepresenter < Roar::Decorator
  include Roar::JSON

  property :video_id
  property :comment_id
  property :published_at
  property :updated_at
  property :text_display
  property :like_count
end
