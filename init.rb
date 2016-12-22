# frozen_string_literal: true
Dir.glob('./{config,lib,models,controllers,queries,representers,services,values,workers}/init.rb').each do |file|
  require file
end
