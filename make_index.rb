#!/usr/bin/env ruby
# Id$ nonnax 2022-02-26 16:24:04 +0800
puts 'index'

# first row as header 13-1
cmds=
[
  './flixer mov 1 | head -n20', 
  './flixer tv 1 | head -n20'
]

cmds.each do |cmd| 
  IO
    .popen(cmd, &:readlines)
    .each{ |l| puts l.chomp }
end
