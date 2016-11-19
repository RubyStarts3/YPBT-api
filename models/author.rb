# frozen_string_literal: true

# Represents an author's stored information
class Author < Sequel::Model
  one_to_one :comment
end
