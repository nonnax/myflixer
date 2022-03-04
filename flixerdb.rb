#!/usr/bin/env ruby
# Id$ nonnax 2022-03-04 14:51:46 +0800
require 'gdbm'
require './flixer'
t=[]
GDBM.open('myflixer.db') do |db|
  10.times do |i|
    t<<Thread.new do 
      group=get_rows(i, type: 'tv') rescue nil
      if group
        group.each do |rows|
          p [i, rows.size]
          rows.each do |row|
            _, k, v=row.split("\t")
            db[k]=v unless db.key?(k)
          end
        end
      end
    end
  end
  t.each(&:join)
end
