# frozen_string_literal: true

CommentInfo = Struct.new :video_id, :comment_id, :published_at, :updated_at,
                         :text_display, :like_count
