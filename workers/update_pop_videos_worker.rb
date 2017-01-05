# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

require_relative 'load_workers'

class UpdatePopVideosWorker
  extend Econfig::Shortcut

  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))
  ENV['YOUTUBE_API_KEY']       = config.YOUTUBE_API_KEY
  ENV['AWS_ACCESS_KEY_ID']     = config.AWS_ACCESS_KEY_ID
  ENV['AWS_SECRET_ACCESS_KEY'] = config.AWS_SECRET_ACCESS_KEY
  ENV['AWS_REGION']            = config.AWS_REGION

  Shoryuken.configure_client do |shoryuken_config|
    shoryuken_config.aws = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:            ENV['AWS_REGION']
    }
  end

  include Shoryuken::Worker
  shoryuken_options queue: config.POPVIDEO_QUEUE, auto_delete: true

  def perform(_sqs_msg, worker_params)
    params = JSON.parse(worker_params)
    video_id = params['video_id']
    channel_id = params['channel_id']

    puts "REQUEST: #{video_id}"
    #Update2LatestQuery.call(video_id)

    unless channel_id.nil?
      puts "channel_id: #{channel_id}"
    end    

    puts "success!"
    #puts "RESULT: #{result.value}"

    #HttpResultRepresenter.new(result.value).to_status_response
  end
end
