# frozen_string_literal: true

# Author record management
class AuthorRecord
  @author_columns = [:id, :comment_id, :author_name, :author_image_url,
                     :author_channel_url, :like_count]

  # Create new author record
  def self.create(author_info)
    author = Author.create()
    update(author.id, author_info)
  end

  # Find author record
  def self.find(author_info)
    columns = @author_columns[0..-1]
    results = Author.where()
    columns.each do |col|
      val = author_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      author_found = AuthorInfo.new()
      columns.each do |col|
        col_setter = (col.to_s + "=").to_sym
        column_value = results.first.send(col)
        author_found.send(col_setter, column_value)
      end
      author_found
    else
      nil
    end
  end

  # Update existed author record
  def self.update(id, author_info)
    author = Author.find(id: id)

    columns = @author_columns[1..-1]
    columns.each do |col|
      val = author_info.send(col)
      author.send("#{col}=", author_info.send(col)) unless val.nil?
    end

    author.save
  end
end
