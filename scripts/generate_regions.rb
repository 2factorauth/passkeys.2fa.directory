#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'net/http'
require 'json'
require 'yaml'
require 'uri'

# Fetch API files
module API
  def self.fetch(uri)
    response = Net::HTTP.get_response URI(uri)

    if response.code.eql? "200"
      return JSON.parse(response.body)
    else
      puts uri
      puts response.code
      puts response.body
    end
  end
end

path = ENV['LOCAL_2FA_PATH']
regions = if path
            JSON.parse(File.open("#{path}/private/regions.json", "r:UTF-8", &:read))
          else
            API.fetch('https://passkeys-api.2fa.directory/private/regions.json')
          end
entries = if path
            JSON.parse(File.open("#{path}/private/all.json", "r:UTF-8", &:read))
          else
            API.fetch('https://passkeys-api.2fa.directory/private/all.json')
          end
categories = JSON.parse(File.open('./data/categories.json', "r:UTF-8", &:read))
identifiers = JSON.parse(File.open('./data/region_identifiers.json', "r:UTF-8", &:read))
used_regions = []
regions.each do |id, region|
  next unless region['count'] >= 10 && !id.eql?('int')

  identifiers.key?(id) ? identifiers[id]&.each { |r| used_regions.push(r) } : used_regions.push(id)

  used_categories = {}
  entries.each do |_, entry|
    entry_regions = entry['regions']
    unless entry_regions.nil?
      included = entry_regions.reject { |r| r.start_with?('-') }
      excluded = entry_regions.select { |r| r.start_with?('-') }.map! { |v| v.tr('-', '') }
      next if (!included.empty? && !included.include?(id)) || excluded.include?(id)
    end
    if entry['categories'].is_a?(Array)
      entry['categories'].each { |category| used_categories.merge!(categories.slice(category)) }
    else
      used_categories.push entry['categories']
    end
  end
  File.open("./data/#{id}.json", 'w') { |file| file.write used_categories.sort.to_h.to_json }
end

all_regions = API.fetch('https://raw.githubusercontent.com/stefangabos/world_countries/master/data/countries/en/world.json')
                 .select { |region| used_regions.include?(region['alpha2']) }
                 .map { |region| [region['alpha2'], region['name']] }.to_h

# Change long official names
change_names = { 'us' => 'United States',
                 'gb' => 'United Kingdom',
                 'tw' => 'Taiwan',
                 'ru' => 'Russia',
                 'kr' => 'South Korea' }
all_regions = all_regions.merge(change_names.select { |country, _| all_regions.key?(country) })

# Flags for these regions should have square geometry
square_flags = %w[ch np va]

# Change output format to array of hashmaps
output = all_regions.map do |k, v|
  { 'id' => k, 'name' => v }
    .tap { |h| h['square_flag'] = 1 if square_flags.include?(k) }
end
File.open('data/regions.yml', 'w') { |file| file.write output.to_yaml }

output.each do |region|
  dir = "content/#{region['id']}"
  FileUtils.mkdir_p dir
  File.open("#{dir}/_index.md", 'w') do |file|
    file.write("#{{ 'layout' => 'tables', 'region' => region }.to_yaml}---")
  end
end
