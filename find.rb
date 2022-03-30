#!/usr/bin/env ruby
# Id$ nonnax 2022-03-04 15:21:19 +0800
require 'gdbm'
require 'optparse'

q=ARGV
hdb=
GDBM.open("myflixer.db") do |db|
  db.to_h
end

hdb
.select{|k, _| 
  # p re_union=Regexp.union(q)
  # k.match?(re_union) #or any
  q.all?{|e| k.match?(/#{e}/i) }
}
.map{|h| puts h.join("\t")}
