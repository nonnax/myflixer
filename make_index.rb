#!/usr/bin/env ruby
# Id$ nonnax 2022-02-26 16:24:04 +0800
puts 'index'

# first row as header 13-1
cmds=
[
  './flixer 1 mov | head -n13', 
  './flixer 1 tv  | head -n13'
]

cmds.each do |cmd| 
  IO
    .popen(cmd, &:readlines)
    .each{ |l| puts l.chomp }
end
