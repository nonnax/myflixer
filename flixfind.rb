#!/usr/bin/env ruby
# Id$ nonnax 2022-03-05 20:38:23 +0800
require 'json'

type, *q=ARGV
fail 'wrong args' unless [q, type].flatten.all?
show_type=%w[mov tv].grep( /#{type}/).first
jfile="myflixer-#{show_type}.json"
jdata=JSON.parse(File.read jfile, symbolize_keys: true)

p [jdata.size, jdata.class]

jdata
.select{|k, _| 
  q.all?{|e| k.match?(/#{e}/i) } 
}
.each{|k, v| 
    v.transform_keys(&:to_sym)=>{link:, image:}

    puts [k, link, image].join("\t")
}
