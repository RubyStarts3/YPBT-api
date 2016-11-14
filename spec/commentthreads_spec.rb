# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Commentthreads Routes' do
  before do
    VCR.insert_cassette COMMENTS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Get the first three comments from a video' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      post 'api/v0.1/video', { url: HAPPY_VIDEO_URL }.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it '[HAPPY]: should find the first three comments' do
      get "api/v0.1/video/#{Video.first.video_id}/commentthreads"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      comments_data = JSON.parse(last_response.body)
      comments_data.size.must_equal 3
      first_comment = comments_data.first
      first_comment['author_name'].length.must_be :>=, 0
      first_comment['comment_text'].length.must_be :>=, 0
      first_comment['like_count'].to_s.length.must_be :>=, 0
      first_comment['author_channel_url'].length.must_be :>=, 0
    end

    it '[SAD]: should report if the commentthreads cannot be found' do
      get "api/v0.1/video/#{SAD_VIDEO_ID}/commentthreads"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
  end
end
