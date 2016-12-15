# frozen_string_literal: true

# Represents collected timetag's information as thread for JSON API output
class TimetagGeneralThreadRepresenter
  attr_accessor :timetags_info

  def initialize(timetags_info)
    @timetags_general = timetags_info.map do |timetag_info|
      JSON.parse(TimetagGeneralRepresenter.new(timetag_info).to_json)
    end
  end

  def to_json
    @timetags_general.to_json
  end
end
