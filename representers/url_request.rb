# frozen_string_literal: true

class UrlRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :url
end
