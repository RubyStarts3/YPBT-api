# frozen_string_literal: true

# Timetag record management
class TimetagRecord
  @timetag_columns =
    [:id, :comment_id, :click_count, :yt_like_count, :our_like_count,
     :our_dislike_count, :tag_type, :start_time, :end_time,
     :start_time_percentage, :end_time_percentage]

  # Create new timetag record
  def self.create(timetag_info)
    existed_timetag = Timetag.find(comment_id: timetag_info.comment_id,
                                   start_time: timetag_info.start_time)
    return existed_timetag unless existed_timetag.nil?

    timetag = Timetag.create()
    update(timetag.id, timetag_info)
  end

  # Find timetag record
  def self.find(timetag_info)
    timetags_found = find_all(timetag_info)
    if timetags_found
      timetags_found.first
    else
      nil
    end
  end

  # Find all match timetag records
  def self.find_all(timetag_info)
    columns = @timetag_columns[0..-1]
    results = Timetag.where()
    columns.each do |col|
      val = timetag_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    render_info = lambda { |result|
      timetag_found = TimetagInfo.new()
      columns.each do |col|
        col_setter = (col.to_s + "=").to_sym
        column_value = result.send(col)
        timetag_found.send(col_setter, column_value)
      end
      timetag_found
    }

    unless results.first.nil?
      timetags_found = results.map &render_info
    else
      nil
    end
  end

  # Update existed timetag record
  def self.update(id, timetag_info)
    timetag = Timetag.find(id: id)

    columns = @timetag_columns[1..-1]
    columns.each do |col|
      val = timetag_info.send(col)
      timetag.send("#{col}=", timetag_info.send(col)) unless val.nil?
    end

    timetag.save
  end

  def self.add_one_click(id)
    timetag = Timetag.find(id: id)
    timetag.click_count += 1
    timetag.save
  end

  def self.add_one_like(id)
    timetag = Timetag.find(id: id)
    timetag.our_like_count += 1
    timetag.save
  end

  def self.add_one_dislike(id)
    timetag = Timetag.find(id: id)
    timetag.our_dislike_count += 1
    timetag.save
  end
end
