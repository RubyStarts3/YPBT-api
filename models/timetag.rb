# frozen_string_literal: true

# Represents a timetag's stored information
class Timetag < Sequel::Model
  many_to_one :comment
end
