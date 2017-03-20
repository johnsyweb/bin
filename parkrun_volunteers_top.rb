#!/usr/bin/env ruby

require 'csv'

summary_file = ARGV.first

volunteers = Hash.new(0)

CSV.foreach(summary_file) do |r|
  r.reject { |c| c =~ / parkrun # / }.each do |c|
    volunteers[c.strip] += 1
  end
end

volunteers.sort_by(&:last).reverse.each { |k,v| puts "#{k}, #{v}" }.size
