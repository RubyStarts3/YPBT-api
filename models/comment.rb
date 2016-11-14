# frozen_string_literal: true

# Represents a comment's stored information
class Comment < Sequel::Model
  many_to_one :video
end
