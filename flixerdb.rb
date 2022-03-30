#!/usr/bin/env ruby
# Id$ nonnax 2022-03-04 14:51:46 +0800
require 'gdbm'
require 'csv'
require 'json'
require 'benchmark'
require './flixer'

data=Hash.new({})
def show_type
  ARGV.first || 'tv'
end

t=[]

def csv_push(&block)
  CSV.open("myflixer-#{show_type.strip}.csv", 'w', &block)
end

# csv_push{|csv|
info=Benchmark.measure do 
  100.times do |i|
    t<<Thread.new(data) do |data|
      get_rows(i, t: show_type) do |group|
         group=>[title,link,image] 
         data[title]={link:, image:}
      end
    end
  end
  t.each(&:join)
  # }

  # p data
  jfile="myflixer-#{show_type}.json"
  File.write(jfile, data.to_json)
  jdata=JSON.parse(File.read jfile)
  p [jdata.size, jdata.class]
end

puts info

