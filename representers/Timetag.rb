# frozen_string_literal: true

# Represents overall video information for JSON API output
class TimetagRepresenter < Roar::Decorator
  include Roar::JSON

  property :comment_id
  property :yt_like_count
  property :our_like_count
  property :start_time
end
