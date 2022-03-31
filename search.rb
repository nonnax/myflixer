#!/usr/bin/env ruby
# Id$ nonnax 2022-04-01 00:20:44 +0800
require 'mechanize'

q,=ARGV
BASELINE='https://myflixer.to'
u="https://myflixer.to/search/#{q}"
agent=Mechanize.new
doc=agent.get(u)

links={}
# res=doc.search('//div[@class="film-poster"]//img', '//div[@class="film-poster"]//a')

links=doc.links.select{|a|
  a.node.parent.search('..//div[@class="film-poster"]')
  set=a.node.parent.search('./a', './img')
  next unless set.map(&:name)==['a','img']
  link, img = set
  p [link['title'], link['href'], img['data-src']]

}
# 
links.each do |k|
   set=k.node.parent.search('./a', './img')
   next unless set.map(&:name)==['a','img']
   link, img = set
   p [link['title'], [BASELINE,link['href']].join('/'), img['data-src']]
end
