# frozen_string_literal: true

# publish new TimeTag
class PublishNewTimetagQuery
  def self.call(video_id, timetag_info)
    channel_id = video_id
    timetag_json = TimetagGeneralRepresenter.new(timetag_info).to_json
    EM.run {
      client = Faye::Client.new("#{ENV['YPBT_APP']}/faye")
      client.publish(
        "/#{channel_id}",
        'text' => "#{timetag_json}",
        'attempts' => 1
      )
    }
  end
end
