# frozen_string_literal: true

# Represents collected comments's information as thread for JSON API output
class CommentInfoThreadRepresenter
  def initialize(comments)
    @comments = comments.map do |comment|
      JSON.parse(CommentInfoRepresenter.new(comment).to_json)
    end
  end

  def to_json
    @comments.to_json
  end
end
