#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'json'
require 'uri'
require 'parallel'

def check_image(image)
  headers = ENV['img_headers'] ? JSON.parse(ENV['img_headers']) : nil
  res = Net::HTTP.get_response(URI("https://api.passkeys.2fa.directory/icons/#{image[0]}/#{image}"), headers)
  res.code.eql? '200'
end

path = ENV['LOCAL_2FA_PATH']
response = path ? File.read("#{path}/private/all.json") : Net::HTTP.get(URI('https://api.passkeys.2fa.directory/private/all.json'))
entries = {}

Parallel.each(JSON.parse(response), in_threads: 16) do |name, entry|
  entry['categories'].each do |category|
    entries[category] = {} unless entries.key? category
    entry['img_src'] = 'https://api.2fa.directory/icons/' unless check_image(entry['img'] || "#{entry['domain']}.svg")
    entries[category].merge!({ name => entry })
  end
end

File.open('./data/entries.json', 'w') { |file| file.write entries.sort.to_h.to_json }
