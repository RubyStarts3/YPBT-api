# frozen_string_literal: true

# Video record management
class VideoRecord
  @video_columns =
    [:id, :video_id, :title, :description, :view_count, :like_count,
     :dislike_count, :duration, :channel_id, :channel_title,
     :channel_description, :channel_image_url, :last_update_time]

  # Create new video record
  def self.create(video_info)
    video = Video.create()
    update(video.id, video_info)
  end

  # Find video record
  def self.find(video_info)
    columns = @video_columns[0..-1]
    results = Video.where()
    columns.each do |col|
      val = video_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      video_found = VideoInfo.new()
      columns.each do |col|
        col_setter = (col.to_s + "=").to_sym
        column_value = results.first.send(col)
        video_found.send(col_setter, column_value)
      end
      video_found
    else
      nil
    end
  end

  # Get all video records
  def self.get_all_videos()
    columns = @video_columns[0..-1]
    results = Video.where()

    render_info = lambda { |result|
      video_found = VideoInfo.new()
      columns.each do |col|
        col_setter = (col.to_s + "=").to_sym
        column_value = result.send(col)
        video_found.send(col_setter, column_value)
      end
      video_found
    }

    unless results.first.nil?
      videos_found = results.map &render_info
    else
      nil
    end
  end

  # Update existed video record
  def self.update(id, video_info)
    video = Video.find(id: id)

    columns = @video_columns[1..-2]
    columns.each do |col|
      val = video_info.send(col)
      video.send("#{col}=", video_info.send(col)) unless val.nil?
    end

    video.last_update_time = Time.now
    video.save
  end
end
