# frozen_string_literal: true

# GroupAPI web service
class YPBT_API < Sinatra::Base
  extend Econfig::Shortcut

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    ENV['YOUTUBE_API_KEY'] = config.YOUTUBE_API_KEY
  end

  API_VER = 'api/v0.1'

  get '/?' do
    "YPBT_API latest version endpoints are at: /#{API_VER}/"
  end
end
