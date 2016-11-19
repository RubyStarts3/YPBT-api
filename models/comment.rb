# frozen_string_literal: true

# Represents a comment's stored information
class Comment < Sequel::Model
  many_to_one :video
  one_to_many :timetags
  one_to_one  :author
end
