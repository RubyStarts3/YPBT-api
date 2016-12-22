# frozen_string_literal: true

# GroupAPI web service
class YPBT_API < Sinatra::Base
  extend Econfig::Shortcut

  Shoryuken.configure_server do |config|
    config.aws = {
      access_key_id:      config.AWS_ACCESS_KEY_ID,
      secret_access_key:  config.AWS_SECRET_ACCESS_KEY,
      region:             config.AWS_REGION
    }
  end

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    ENV['YOUTUBE_API_KEY'] = config.YOUTUBE_API_KEY
  end

  API_VER = 'api/v0.1'

  after do
    content_type 'application/json'
  end

  get '/?' do
    {
      status: 'OK',
      message: "YPBT_API latest version endpoints are at: /#{API_VER}/"
    }.to_json
  end
end
