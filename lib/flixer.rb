#!/usr/bin/env ruby
# Id$ nonnax 2022-02-17 13:07:07 +0800
require 'mechanize'
require 'pp'
require 'rubytools/numeric_ext'
require 'rubytools/cache'

URL_ROOT='https://myflixer.to'

def get_pages
  t, i, _=ARGV
  i ||= 1
  i &&= i.to_i-1
  t ||= 'tv'
  pages=(i..(i+3))
  page_set = 15_000.pages_of(5)
  pages.each do |i|
    # res=Cache.cached([t,pages.join].join, ttl: 300*6) do
    res =  work( page_set[i], t: t)
    # end
    puts res
  end
  # puts res
end

def get(i, type: 'mov')
  work i, type
end

def work pg, t: 'tv'
  type = %w[tv-show movie].grep(/#{t}/).first
  t = type.sub('-show', '')
  res=[t]
  th=[]
  pages=[]
  # pager=50.pages_of(5)

  pg.each do |i|
   th << Thread.new(i, type) do |i|
      url="https://myflixer.to/#{type}?page=#{i}"
      agent=Mechanize.new
      page=agent.get(url)
      pages<<page
    end
  end

  th.map(&:join)
  # 
  res+=
  pages.map do |page|
    page
      .search('//img[contains(@class,"film-poster-img")]')
      .map do |e| 
        ea=e.attributes 
         [
          ea['data-src'], 
          ea['alt'], 
          e.parent
            .search('a')
            .map do |a| 
              [].tap do |url_build|
                url=a.attributes["href"].value
                url_build<<url
                url_build.prepend(URL_ROOT) if url.match(/^\//)
              end.join 
            end
            .last          
          ]
         .map(&:to_s) 
         .join("\t") 
      end
  end
end

get_pages
