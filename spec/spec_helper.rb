# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'
sh "rake db:migrate"

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

include Rack::Test::Methods

def app
  YPBT_API
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
VIDEOS_CASSETTE = 'videos'
COMMENTS_CASSETTE = 'comments'
TIMETAGS_CASSETTE = 'timetags'
AUTHORS_CASSETTE = 'authors'
#CASSETTE_FILE = 'youtube_api'
#RESULT_FILE = "#{FIXTURES_FOLDER}/yt_api_results.yml"
#YT_RESULT = YAML.load(File.read(RESULT_FILE))

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  unless ENV['YOUTUBE_API_KEY']
    ENV['YOUTUBE_API_KEY'] = app.config.YOUTUBE_API_KEY
  end

  c.filter_sensitive_data('<API_KEY>') { ENV['YOUTUBE_API_KEY'] }
  c.filter_sensitive_data('<API_KEY_ESCAPED>') do
    URI.unescape(ENV['YOUTUBE_API_KEY'])
  end
end

HAPPY_VIDEO_ID = 'OyDSCKYz5sA'
SAD_VIDEO_ID = 'XxXx888xXxX'
#REMOVED_VIDEO_ID = '5BTjZ9U5XF8'
HAPPY_VIDEO_URL = 'https://www.youtube.com/watch?v=OyDSCKYz5sA'
SAD_VIDEO_URL = 'https://www.youtube.com/watch?v=XxXx888xXxX'
