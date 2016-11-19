# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:authors) do
      primary_key :id
      foreign_key :comment_id
      String :author_name
      String :author_image_url
      String :author_channel_url
      Integer :like_count
    end
  end
end
