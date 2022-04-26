#!/usr/bin/env ruby
# Id$ nonnax 2022-04-26 09:37:05 +0800
require 'rubytools/noko_party'
require 'json'
u='https://myflixer.to/tv-show?page=1'
ROOT='https://myflixer.to'
data={}
@doc=NokoParty.get(u)
@doc.search('.film-poster').each_with_index{|d, i| 
  div, img, link = d.children.reject{|c| c.name=='text'}
  info=d.parent.search('.film-detail .fd-infor').text
  h=%i(img link title meta).zip( [img[:'data-src'], ROOT+link[:href], link[:title], ([div.text]+info.split).join(' ')]).to_h
  data[h[:link]]=h
}

puts JSON.pretty_generate(data)
