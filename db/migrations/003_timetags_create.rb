# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:timetags) do
      primary_key :id
      foreign_key :comment_id
      Integer :yt_like_count
      Integer :our_like_count
      String :tag_type
      String :start_time
      String :end_time
      String :duration
    end
  end
end
