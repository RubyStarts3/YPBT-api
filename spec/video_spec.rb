# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Video Routes' do
  before do
    VCR.insert_cassette VIDEOS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find Video by its Video ID' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      post 'api/v0.1/video', { url: HAPPY_VIDEO_URL }.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it '[HAPPY]: should find a video given a correct id' do
      get "api/v0.1/video/#{Video.first.video_id}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      video_data = JSON.parse(last_response.body)
      video_data['video_id'].length.must_be :>, 0
      video_data['title'].length.must_be :>, 0
    end

    it '[SAD]: should report if a video is not found' do
      get "api/v0.1/video/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_VIDEO_ID
    end
  end

  describe 'Loading and saving a new video by video_id' do
    before do
      DB[:videos].delete
      DB[:comments].delete
    end

    it '[HAPPY]: should load and save a new video by its video_id' do
      post 'api/v0.1/video',
           { url: HAPPY_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'video_id'
      body.must_include 'title'

      Video.count.must_equal 1
      Comment.count.must_be :>=, 3
    end

    it '[BAD]: should report error if given invalid video_id' do
      post 'api/v0.1/video',
           { url: SAD_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end

    it 'should report error if video already exists' do
      2.times do
        post 'api/v0.1/video',
             { url: HAPPY_VIDEO_URL }.to_json,
             'CONTENT_TYPE' => 'application/json'
      end

      last_response.status.must_equal 422
    end
  end

  describe 'Request to update a video (including its followed comments)' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      post 'api/v0.1/video',
           { url: HAPPY_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it '[HAPPY]: should successfully update valid video' do
      original = Video.first
      modified = Video.first
      Video.first.comments.each { |comment| comment.delete }
      put "api/v0.1/video/#{original.video_id}"
      last_response.status.must_equal 200
      updated = Video.first
      updated.comments.size.must_equal(original.comments.size)
    end

    it '[BAD]: should report error if given invalid video_id' do
      put "api/v0.1/video/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
=begin
    it '[BAD]: should report error if stored video removed from YouTube' do
      original = Video.first
      original.update(video_id: REMOVED_VIDEO_ID).save

      put "api/v0.1/video/#{original.video_id}"

      last_response.status.must_equal 404
      last_response.body.must_include original.video_id
    end
=end
  end
end
