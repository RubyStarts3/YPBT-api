# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :video_id
      String :comment_id
      String :updated_at
      String :published_at
      String :text_display
      String :author_name
      String :author_image_url
      String :author_channel_url
      Int :like_count
    end
  end
end
