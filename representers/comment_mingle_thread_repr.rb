# frozen_string_literal: true

# Represents collected comments's information as thread for JSON API output
class CommentMingleThreadRepresenter
  attr_accessor :video_id, :comments_info, :authors_info

  def initialize(video_id, comments_info, authors_info)
    video_info = VideoInfo.new(video_id: video_id)
    zip_info   = comments_info.zip(authors_info)
    @comments_mingle = zip_info.map do |comment_info, author_info|
      JSON.parse(CommentMingleRepresenter.new(
        video_info, comment_info, author_info).to_json)
    end
  end

  def to_json
    @comments_mingle.to_json
  end
end
