# frozen_string_literal: true
require 'faye'
require 'eventmachine'
require './init.rb'

use Faye::RackAdapter, :mount => '/faye', :timeout => 25 do |bayeux|
  puts "puts anything."
  hash_table = {}
  expiry_time = {}
  POP_VIDEO_NUM = 20

  bayeux.on(:publish) do |client_id,channel,data|
    puts "#{client_id} published #{channel}: #{data}"

    channel_id = channel.gsub(/\//, "")

    if hash_table[channel_id].nil?
      hash_table[channel_id] = []
      expiry_time[channel_id] = Time.now + 200
    end

    hash_table[channel_id].push data
    count = hash_table[channel_id].size
    if count < POP_VIDEO_NUM
      client_publish(channel_id, count)
    elsif count >= POP_VIDEO_NUM
      10.times { client_publish(channel_id, count); sleep(1); }
    end

    expiry_time.each do |key, time|
      if expiry_time[key] < Time.now
        hash_table.delete key
        expiry_time.delete key
      end
    end
  end
end
run YPBT_API

def client_publish(channel_id, count)
  EM.run {
    client = Faye::Client.new("#{ENV['YPBT_APP']}/faye")
    client.publish("/#{channel_id}", 'text' => "#{count}", 'attempts' => 1)
  }
end
