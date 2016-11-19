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
      Integer :like_count
    end
  end
end
