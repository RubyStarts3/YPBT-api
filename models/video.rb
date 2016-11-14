# frozen_string_literal: true

# Represents a video's stored information
class Video < Sequel::Model
  one_to_many :comments
end
