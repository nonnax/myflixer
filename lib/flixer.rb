#!/usr/bin/env ruby
# Id$ nonnax 2022-02-17 13:07:07 +0800
require 'mechanize'
require 'pp'
require 'rubytools/numeric_ext'
require 'rubytools/cache'

URL_ROOT='https://myflixer.to'


def get_pages
  i, t, _=ARGV
  i ||= 1
  i && i.to_i-1
  t ||= 'tv'

  res=Cache.cached([i,t].join, ttl: 600) do
    work i, t
  end
  puts res
end

def get(i, type: 'mov')
  work i, type
end

def work pg, t
  
  type = %w[tv-show movie].grep(/#{t}/).first
  t = type.sub('-show', '')
  res=[t]
  th=[]
  pages=[]
  pager=50.pages_of(5)

  pager[pg.to_i].each do |i|
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

# .map{|a| [URL_ROOT, a.attributes["href"].value].join }

# found = pages.first.links.select{|e| !e.text.empty? && e.href.to_s.match(/genre\//) }
# found.each do |pg|
  # puts pg.text.strip
# end
# 
# re=Regexp.new "#{t}\/"
# 
# pages.map do |page|
  # page
  # .links
  # .select{|e| !e.text.empty? && e.href.to_s.match(re) }
  # .sort_by{|e| e.text}
# end
# .flatten
# .each do |pg|
    # # p (pg.methods - Object.methods)
    # puts [pg.text, pg.resolved_uri.to_s].join("\t")
    # # puts pg.text
  # end

# pp found.click
# pages.map do |page|
  # page.search('//img[contains(@class,"film-poster-img")]')
      # .map{|e|
          # ea=e.attributes
          # puts [ea['alt'], ea['data-src']]
                # .map(&:to_s)
                # .join("\t")
       # }
# end

