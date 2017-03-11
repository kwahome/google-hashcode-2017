#!/usr/bin/ruby
require_relative './slice.rb'


input_file_name = ARGV[0] || 'example'
input_file_path = "output/#{input_file_name}.out"
puts "Hello! Sit tight. I'm checking your solution #{input_file_path}"
@file = File.read(input_file_path)
@lines = @file.split(/\n/)
@first_line = @lines[0].split
@slices = @lines[1..-1].map(&:split)
puts "Nice! You had #{@slices.count} slices"
@slices.each do |slice1_ary|
  slice1 = Slice.from_coordinates(*slice1_ary)
  @slices.each do |slice2_ary|
    slice2 = Slice.from_coordinates(*slice2_ary)
    next if slice1_ary == slice2_ary
    raise Exception.new('Slices are overlapping!') if slice1.overlaps?(slice2)
  end
end
puts "Your solution is good! Kudos!"