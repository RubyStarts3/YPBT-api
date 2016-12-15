# frozen_string_literal: true

# Comment record management
class CommentRecord
  @comment_columns =
    [:id, :video_id, :comment_id, :published_at, :updated_at,
     :text_display, :like_count]

  # Create new comment record
  def self.create(comment_info)
    comment = Comment.create()
    update(comment.id, comment_info)
  end

  # Find comment record
  def self.find(comment_info)
    comments_found = find_all(comment_info)
    if comments_found
      comments_found.first
    else
      nil
    end
  end

  # Find all match comment records
  def self.find_all(comment_info)
    columns = @comment_columns[0..-1]
    results = Comment.where()
    columns.each do |col|
      val = comment_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    render_info = lambda { |result|
      comment_found = CommentInfo.new()
      columns.each do |col|
        col_setter = (col.to_s + "=").to_sym
        column_value = result.send(col)
        comment_found.send(col_setter, column_value)
      end
      comment_found
    }

    unless results.first.nil?
      comments_found = results.map &render_info
    else
      nil
    end
  end

  # Update existed comment record
  def self.update(id, comment_info)
    comment = Comment.find(id: id)

    columns = @comment_columns[1..-1]
    columns.each do |col|
      val = comment_info.send(col)
      comment.send("#{col}=", comment_info.send(col)) unless val.nil?
    end

    comment.save
  end
end
