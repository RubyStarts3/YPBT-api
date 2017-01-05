# frozen_string_literal: true
require 'faye'
require 'eventmachine'
require './init.rb'

use Faye::RackAdapter, :mount => '/faye', :timeout => 25 do |bayeux|
  hash_table = {}
  expiry_time = {}

  bayeux.on(:publish) do |client_id,channel,data|
    puts "#{client_id} published #{channel}: #{data}"

    channel_id = channel.gsub(/\//, "")

    if hash_table[channel_id].nil?
      hash_table[channel_id] = []
      expiry_time[channel_id] = Time.now + 200
    end

    hash_table[channel_id].push data
    count = hash_table[channel_id].size
    EM.run {
      client = Faye::Client.new("#{ENV['YPBT_APP']}/faye")
      client.publish("/#{channel_id}", 'text' => "#{count}")
    }

    if count == 20
      hash_table.delete channel_id
    end

    expiry_time.each do |key, time|
      expiry_time.delete key if expiry_time[key] < Time.now
    end
  end
end
run YPBT_API
