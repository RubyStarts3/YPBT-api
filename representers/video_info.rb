# frozen_string_literal: true

# Represents overall video information for JSON API output
class VideoInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :video_id
  property :title
  property :description
  property :view_count
  property :like_count
  property :dislike_count
  property :duration
end
