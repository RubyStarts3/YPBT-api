# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
require './lib/YPBT/comment.rb'
require './lib/YPBT/video.rb'
require './lib/YPBT/author.rb'
require './lib/YPBT/youtube_api.rb'

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
CASSETTE_FILE = 'youtube_api'
TEST_VIDEO_ID = 'FugHj7MGhss'
RESULT_FILE = "#{FIXTURES_FOLDER}/yt_api_results.yml"
YT_RESULT = YAML.load(File.read(RESULT_FILE))

unless ENV.key? 'YOUTUBE_API_KEY'
  CREDENTIALS = YAML.load(File.read('config/credentials.yml'))
  ENV['YOUTUBE_API_KEY'] = CREDENTIALS[:YOUTUBE_API_KEY]
end
